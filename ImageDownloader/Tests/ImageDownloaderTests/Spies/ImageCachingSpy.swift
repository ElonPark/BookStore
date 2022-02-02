//
//  ImageCachingSpy.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import Foundation
import UIKit
@testable import ImageDownloader

final class ImageCachingSpy: ImageCaching {

    var totalMemoryCostLimit: Int = 0

    var memoryCache: MemoryCaching
    var diskCache: DiskCaching?

    private(set) var hasCachedImageCallCount = 0
    private(set) var cachedImageCallCount = 0
    private(set) var storeImageCallCount = 0
    private(set) var removeCallCount = 0
    private(set) var removeAllCallCount = 0

    init(memoryCache: MemoryCaching, diskCache: DiskCaching?) {
        self.memoryCache = memoryCache
        self.diskCache = diskCache
    }

    func hasCachedImage(by url: URL) -> Bool {
        hasCachedImageCallCount += 1
        return true
    }

    func cachedImage(by url: URL) -> UIImage? {
        cachedImageCallCount += 1
        return nil
    }

    func store(image: UIImage, with url: URL) {
        storeImageCallCount += 1
    }

    func remove(forKey key: CacheKey) {
        removeCallCount += 1
    }

    func removeAll() {
        removeAllCallCount += 1
    }
}
