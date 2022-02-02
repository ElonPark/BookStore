//
//  DiskCacheSpy.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import Foundation
@testable import ImageDownloader

final class DiskCacheSpy: DiskCaching {
    var totalCacheSize: Int = 0
    var maxCapacity: Int = 0
    var loadFactor: Double = 0
    var initialCleaningInterval: DispatchTimeInterval = .seconds(0)
    var cleaningInterval: DispatchTimeInterval = .seconds(0)
    
    private(set) var containsCallCount = 0
    private(set) var valueForKeyCallCount = 0
    private(set) var setValueCallCount = 0
    private(set) var removeCallCount = 0
    private(set) var removeAllCallCount = 0
    
    func contains(forKey key: CacheKey) -> Bool {
        containsCallCount += 1
        return true
    }
    
    func value(forKey key: CacheKey) -> ImageContainer? {
        valueForKeyCallCount += 1
        return nil
    }
    
    func setValue(_ imageContainer: ImageContainer, forKey key: CacheKey) {
        setValueCallCount += 1
    }
    
    func remove(forKey key: CacheKey) {
        removeCallCount += 1
    }
    
    func removeAll() {
        removeAllCallCount += 1
    }
}
