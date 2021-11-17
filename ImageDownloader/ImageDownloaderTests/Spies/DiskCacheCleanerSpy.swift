//
//  DiskCacheCleanerSpy.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import Foundation

@testable import ImageDownloader

final class DiskCacheCleanerSpy: DiskCacheCleaning {
    
    var fileManager: DiskCacheFileManager? = nil
    var maxCapacity: Int = 0
    var loadFactor: Double = 0
    
    var cleaningCacheCallCount = 0
    
    func cleaningCache() {
        cleaningCacheCallCount += 1
    }
}
