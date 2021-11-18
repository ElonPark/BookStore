//
//  DiskCache.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation

protocol DiskCaching {
    var maxCapacity: Int { get set }
    var loadFactor: Double { get set }
    var initialCleaningInterval: DispatchTimeInterval { get set }
    var cleaningInterval: DispatchTimeInterval { get set }
    var totalCacheSize: Int { get }
    
    subscript(key: CacheKey) -> ImageContainer? { get set }
    func contains(forKey key: CacheKey) -> Bool
    func value(forKey key: CacheKey) -> ImageContainer?
    func setValue(_ imageContainer: ImageContainer, forKey key: CacheKey)
    func remove(forKey key: CacheKey)
    func removeAll()
}

extension DiskCaching {
    subscript(key: CacheKey) -> ImageContainer? {
        get {
            return value(forKey: key)
        }
        set {
            if let imageContainer = newValue {
                setValue(imageContainer, forKey: key)
            } else {
                remove(forKey: key)
            }
        }
    }
}

final class DiskCache: DiskCaching {
    
    /// Default max capacity is 128MB
    var maxCapacity: Int {
        get { cleaner.maxCapacity }
        set { cleaner.maxCapacity = newValue }
    }
    
    /**
     Load Factor
     
     after cleaning total size is less than equal to `maxCapacity * loadFactor`.
     
     default is `0.8`
     */
    var loadFactor: Double {
        get { cleaner.loadFactor }
        set { cleaner.loadFactor = newValue }
    }
    
    ///  initial cleaning cache after 10 seconds
    var initialCleaningInterval: DispatchTimeInterval
    /// cleaning cache every 30 seconds
    var cleaningInterval: DispatchTimeInterval
    
    var totalCacheSize: Int {
        return queue.sync { totalDiskCacheSize() }
    }
    
    private var cleaner: DiskCacheCleaning
    private var fileManager: DiskCacheFileManager
    
    private let queue = DispatchQueue(label: "com.elonparks.ImageDownloader.diskCache-queue", qos: .utility)
    
    init(
        directoryName: String = "com.elonparks.ImageDownloader.diskCache",
        cleaner: DiskCacheCleaning = DiskCacheCleaner(),
        initialCleaningInterval: DispatchTimeInterval = .seconds(10),
        cleaningInterval: DispatchTimeInterval = .seconds(30)
    ) throws {
        fileManager = try queue.sync {
            return try DiskCacheFileManager(directoryName: directoryName)
        }
        self.cleaner = cleaner
        self.cleaner.fileManager = fileManager
        
        self.initialCleaningInterval = initialCleaningInterval
        self.cleaningInterval = cleaningInterval
        
        try queue.sync {
            try fileManager.createDirectory()
        }
        initialCleaningCache()
    }
    
    private func initialCleaningCache() {
        queue.asyncAfter(deadline: .now() + initialCleaningInterval) { [weak self] in
            self?.scheduledCleaning()
        }
    }
    
    private func scheduledCleaning() {
        cleaner.cleaningCache()
        queue.asyncAfter(deadline: .now() + cleaningInterval) { [weak self] in
            self?.scheduledCleaning()
        }
    }
    
    func contains(forKey key: CacheKey) -> Bool {
        guard let url = url(forKey: key) else { return false }
        return queue.sync {
            return fileManager.contains(with: url)
        }
    }
    
    func value(forKey key: CacheKey) -> ImageContainer? {
        guard let url = url(forKey: key) else { return nil }
        return queue.sync {
            return fileManager.readFromDisk(with: url)
        }
    }
    
    func setValue(_ imageContainer: ImageContainer, forKey key: CacheKey) {
        guard let url = url(forKey: key) else { return }
        queue.sync {
            fileManager.writeToDisk(imageContainer, to: url)
        }
    }
    
    func remove(forKey key: CacheKey) {
        guard let url = url(forKey: key) else { return }
        queue.sync {
            fileManager.removeFromDisk(with: url)
        }
    }
    
    func removeAll() {
        queue.sync {
            fileManager.removeAllFromDisk()
        }
    }
    
    private func url(forKey key: CacheKey) -> URL? {
        guard let filename = self.filename(forKey: key) else { return nil }
        let url = fileManager.url(byFilename: filename)
        return url
    }
    
    private func filename(forKey key: CacheKey) -> String? {
        return String(key.key)
    }
    
    private func totalDiskCacheSize() -> Int {
        let items = fileManager.diskItemIndices(by: [.totalFileAllocatedSizeKey])
        let size = items.reduce(0) { partialResult, diskItemIndex in
            partialResult + (diskItemIndex.metadata.totalFileAllocatedSize ?? 0)
        }
        
        return size
    }
}
