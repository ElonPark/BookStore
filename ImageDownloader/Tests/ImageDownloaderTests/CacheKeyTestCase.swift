//
//  CacheKeyTestCase.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import ImageDownloader

class CacheKeyTestCase: XCTestCase {
    
    func testIsEqualCacheKey() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let key1 = CacheKey(url: url)
        let key2 = CacheKey(url: url)
        
        // When
        let isEqual = key1 == key2
        
        // Then
        XCTAssertTrue(isEqual)
        XCTAssertEqual(key1, key2)
    }
    
    func testIsEqualCacheKeyHash() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let key1 = CacheKey(url: url)
        let key2 = CacheKey(url: url)
        
        // When
        let isEqual = key1.hashValue == key2.hashValue
        
        // Then
        XCTAssertTrue(isEqual)
        XCTAssertEqual(key1.hashValue, key2.hashValue)
    }
    
    func testDifferentCacheKey() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let key1 = CacheKey(url: url1)
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let key2 = CacheKey(url: url2)
        
        // When
        let isEqual = key1 == key2
        
        // Then
        XCTAssertFalse(isEqual)
        XCTAssertNotEqual(key1, key2)
    }
    
    func testDifferentCacheKeyHash() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let key1 = CacheKey(url: url1)
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let key2 = CacheKey(url: url2)
        
        // When
        let isEqual = key1 == key2
        
        // Then
        XCTAssertFalse(isEqual)
        XCTAssertNotEqual(key1.hashValue, key2.hashValue)
    }
}
