//
//  DiskCacheCleaner.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation

protocol DiskCacheCleaning {
    var fileManager: DiskCacheFileManager? { get set }
    var maxCapacity: Int { get set }
    var loadFactor: Double { get set }

    func cleaningCache()
}

final class DiskCacheCleaner: DiskCacheCleaning {

    /// Default max capacity is 128MB
    var maxCapacity: Int = 128 * 1024 * 1024

    /**
     Load Factor

     after cleaning total size is less than equal to `maxCapacity * loadFactor`.

     default is `0.8`
     */
    var loadFactor: Double = 0.8

    weak var fileManager: DiskCacheFileManager?

    private let dateProvider: () -> Date
    private let cacheMaxAge: TimeInterval

    init(
        dateProvider: @escaping () -> Date = Date.init,
        cacheMaxAge: TimeInterval = 12 * 60 * 60
    ) {
        self.dateProvider = dateProvider
        self.cacheMaxAge = cacheMaxAge
    }

    func cleaningCache() {
        let keys: [URLResourceKey] = [.creationDateKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
        guard var items = fileManager?.diskItemIndices(by: keys) else { return }
        guard !items.isEmpty else { return }

        items = cleaningExpiredCache(from: items)
        guard !items.isEmpty else { return }

        var cacheSize = currentCacheSize(from: items)
        guard cacheSize > maxCapacity else { return }

        let targetCacheSize = Int(Double(maxCapacity) * loadFactor)
        items = sortedItemsByLRU(items)

        while cacheSize > targetCacheSize, let lastUsedItem = items.popLast() {
            cacheSize -= lastUsedItem.metadata.totalFileAllocatedSize ?? 0
            fileManager?.removeFromDisk(with: lastUsedItem.url)
        }
    }

    private func cleaningExpiredCache(from items: [DiskItemIndex]) -> [DiskItemIndex] {
        var aliveCacheItems = [DiskItemIndex]()

        let currentDate = dateProvider()
        for item in items {
            let creationDate = item.metadata.creationDate ?? Date.distantPast
            let expirationDate = creationDate.addingTimeInterval(cacheMaxAge)

            if currentDate > expirationDate {
                fileManager?.removeFromDisk(with: item.url)
            } else {
                aliveCacheItems.append(item)
            }
        }

        return aliveCacheItems
    }

    private func currentCacheSize(from items: [DiskItemIndex]) -> Int {
        return items.reduce(0) { partialResult, diskItemIndex in
            partialResult + (diskItemIndex.metadata.totalFileAllocatedSize ?? 0)
        }
    }

    private func sortedItemsByLRU(_ items: [DiskItemIndex]) -> [DiskItemIndex] {
        let pastDate = Date.distantPast
        return items.sorted {
            ($0.metadata.contentAccessDate ?? pastDate) > ($1.metadata.contentAccessDate ?? pastDate)
        }
    }
}
