//
//  MemoryCacheTestCase.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import ImageDownloader

class MemoryCacheTestCase: XCTestCase {
    
    var memoryCache: MemoryCaching!
    
    override func setUpWithError() throws {
        memoryCache = MemoryCache()
    }
    
    func testGetSetImageCache() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let imageContainer = ImageContainer(key: CacheKey(url: url), image: UIImage())
        
        // When
        memoryCache[imageContainer.key] = imageContainer
        
        // Then
        let cachedImageContainer = memoryCache[imageContainer.key]
        let container = try XCTUnwrap(cachedImageContainer)
        XCTAssertEqual(container, imageContainer)
    }
    
    func testContainsImageCache() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let imageContainer = ImageContainer(key: CacheKey(url: url), image: UIImage())
        
        // When
        memoryCache[imageContainer.key] = imageContainer
        let hasImageCache = memoryCache.contains(forKey: imageContainer.key)
        
        // Then
        XCTAssertTrue(hasImageCache)
    }
    
    func testRemoveImageCache() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let imageContainer = ImageContainer(key: CacheKey(url: url), image: UIImage())
        
        // When
        memoryCache[imageContainer.key] = imageContainer
        memoryCache.remove(forKey: imageContainer.key)
        
        // Then
        let cachedImageContainer = memoryCache[imageContainer.key]
        XCTAssertNil(cachedImageContainer)
    }
    
    func testRemoveAllImageCache() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        
        // When
        memoryCache[imageContainer1.key] = imageContainer1
        memoryCache[imageContainer2.key] = imageContainer2
        memoryCache.removeAll()
        
        // Then
        let cachedImageContainer1 = memoryCache[imageContainer1.key]
        let cachedImageContainer2 = memoryCache[imageContainer2.key]
        XCTAssertNil(cachedImageContainer1)
        XCTAssertNil(cachedImageContainer2)
    }
    
    func testMemoryWarning() {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        
        let memoryWarningNotification = Notification(
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            userInfo: nil
        )
        
        // When
        memoryCache[imageContainer1.key] = imageContainer1
        memoryCache[imageContainer2.key] = imageContainer2
        
        NotificationCenter.default.post(memoryWarningNotification)
        
        // Then
        let cachedImageContainer1 = memoryCache[imageContainer1.key]
        let cachedImageContainer2 = memoryCache[imageContainer2.key]
        XCTAssertNil(cachedImageContainer1)
        XCTAssertNil(cachedImageContainer2)
    }
}
