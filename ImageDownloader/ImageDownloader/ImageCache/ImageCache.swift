//
//  ImageCache.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation
import UIKit

protocol ImageCaching {
    var totalMemoryCostLimit: Int { get set }
    var memoryCache: MemoryCaching { get }
    var diskCache: DiskCaching? { get }

    func hasCachedImage(by url: URL) -> Bool
    func cachedImage(by url: URL) -> UIImage?
    func store(image: UIImage, with url: URL)
    func remove(forKey key: CacheKey)
    func removeAll()
}

final class ImageCache: ImageCaching {

    var totalMemoryCostLimit: Int {
        get { memoryCache.totalCostLimit}
        set { memoryCache.totalCostLimit = newValue }
    }
    var diskCacheDirectoryName = "com.elonparks.ImageDownloader.ImageCache"

    private(set) var memoryCache: MemoryCaching
    let diskCache: DiskCaching?

    init(
        memoryCache: MemoryCaching = MemoryCache(),
        diskCache: DiskCaching? = try? DiskCache()
    ) {
        self.memoryCache = memoryCache
        self.diskCache = diskCache
    }

    func hasCachedImage(by url: URL) -> Bool {
        let cacheKey = CacheKey(url: url)
        if memoryCache.contains(forKey: cacheKey) {
            return true
        }

        guard let diskCache = self.diskCache, diskCache.contains(forKey: cacheKey) else { return false }
        return true
    }

    func cachedImage(by url: URL) -> UIImage? {
        let cacheKey = CacheKey(url: url)
        if let imageContainer = memoryCache.value(forKey: cacheKey) {
            return imageContainer.image
        }

        if let imageContainer = diskCache?.value(forKey: cacheKey) {
            return imageContainer.image
        }

        return nil
    }

    func store(image: UIImage, with url: URL) {
        let cacheKey = CacheKey(url: url)
        let imageContainer = ImageContainer(key: cacheKey, image: image)

        memoryCache.setValue(imageContainer, forKey: cacheKey)
        diskCache?.setValue(imageContainer, forKey: cacheKey)
    }

    func remove(forKey key: CacheKey) {
        memoryCache.remove(forKey: key)
        diskCache?.remove(forKey: key)
    }

    func removeAll() {
        memoryCache.removeAll()
        diskCache?.removeAll()
    }
}
