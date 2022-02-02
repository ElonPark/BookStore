//
//  DiskCacheTestCase.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import ImageDownloader

class DiskCacheTestCase: XCTestCase {
    
    var diskCache: DiskCaching!
    var cleaner: DiskCacheCleaning!
    let directoryName = "com.elonparks.ImageDownloader.diskCache"
    var directoryPath: URL!
    
    override func setUpWithError() throws {
        cleaner = DiskCacheCleaner()
        diskCache = try DiskCache(directoryName: directoryName, cleaner: cleaner)
        
        let directoryURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let cachesDirectory = directoryURLs.first else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil)
        }
        
        directoryPath = cachesDirectory.appendingPathComponent(directoryName, isDirectory: true)
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: directoryPath)
    }
    
    func testSetValueToDiskCache() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        diskCache.setValue(imageContainer1, forKey: imageContainer1.key)
        diskCache[imageContainer2.key] = imageContainer2
        
        // Then
        XCTAssertTrue(diskCache.contains(forKey: imageContainer1.key))
        XCTAssertTrue(diskCache.contains(forKey: imageContainer2.key))
    }
    
    func testSetValueToDiskCacheWhenNoSuchFileError() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        try FileManager.default.removeItem(at: directoryPath)
        diskCache.setValue(imageContainer1, forKey: imageContainer1.key)
        diskCache[imageContainer2.key] = imageContainer2
        
        // Then
        XCTAssertTrue(diskCache.contains(forKey: imageContainer1.key))
        XCTAssertTrue(diskCache.contains(forKey: imageContainer2.key))
    }
    
    func testGetValueFromDiskCache() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        diskCache.setValue(imageContainer1, forKey: imageContainer1.key)
        diskCache[imageContainer2.key] = imageContainer2
        
        let savedImageContainer1 = diskCache.value(forKey: imageContainer1.key)
        let savedImageContainer2 = diskCache.value(forKey: imageContainer2.key)
        
        // Then
        let result1 = try XCTUnwrap(savedImageContainer1)
        XCTAssertEqual(result1, imageContainer1)
        XCTAssertTrue(diskCache.contains(forKey: imageContainer1.key))
        
        let result2 = try XCTUnwrap(savedImageContainer2)
        XCTAssertEqual(result2, imageContainer2)
        XCTAssertTrue(diskCache.contains(forKey: imageContainer2.key))
    }
    
    func testContainsDiskCacheWhenHasImageContainer() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let imageContainer = ImageContainer(key: CacheKey(url: url), image: UIImage())
        
        // When
        diskCache[imageContainer.key] = imageContainer
        let result = diskCache.contains(forKey: imageContainer.key)
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testDiskCacheRemove() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let imageContainer = ImageContainer(key: CacheKey(url: url), image: UIImage())
        
        // When
        diskCache[imageContainer.key] = imageContainer
        diskCache.remove(forKey: imageContainer.key)
        
        // Then
        XCTAssertFalse(diskCache.contains(forKey: imageContainer.key))
    }
    
    func testDiskCacheRemoveAll() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        diskCache[imageContainer1.key] = imageContainer1
        diskCache[imageContainer2.key] = imageContainer2
        diskCache.removeAll()
        
        // Then
        XCTAssertFalse(diskCache.contains(forKey: imageContainer1.key))
        XCTAssertFalse(diskCache.contains(forKey: imageContainer2.key))
    }
    
    func testInitialCleaningCache() throws {
        // Given
        let cleaner = DiskCacheCleanerSpy()
        diskCache = try DiskCache(
            directoryName: directoryName,
            cleaner: cleaner,
            initialCleaningInterval: .milliseconds(100)
        )
        
        // When
        let expectation = XCTestExpectation(description: "cleaningCache timeout")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.3)
        let cleaningCacheCallCount = cleaner.cleaningCacheCallCount
        
        // Then
        XCTAssertEqual(cleaningCacheCallCount, 1)
    }
    
    func testScheduledCleaning() throws {
        // Given
        let cleaner = DiskCacheCleanerSpy()
        diskCache = try DiskCache(
            directoryName: directoryName,
            cleaner: cleaner,
            initialCleaningInterval: .milliseconds(50),
            cleaningInterval: .milliseconds(100)
        )
        
        // When
        let expectation = XCTestExpectation(description: "cleaningCache timeout")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.4)
        let cleaningCacheCallCount = cleaner.cleaningCacheCallCount
        
        // Then
        XCTAssertEqual(cleaningCacheCallCount, 3)
    }
}
