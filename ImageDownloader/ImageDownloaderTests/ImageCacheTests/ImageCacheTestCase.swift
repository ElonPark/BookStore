//
//  ImageCacheTestCase.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import ImageDownloader

class ImageCacheTestCase: XCTestCase {

    var imageCache: ImageCaching!

    override func setUpWithError() throws {
        let cleaner = DiskCacheCleaner()
        imageCache = ImageCache(memoryCache: MemoryCache(), diskCache: try? DiskCache(cleaner: cleaner))
    }

    override func tearDownWithError() throws {
        imageCache.memoryCache.removeAll()
        imageCache.diskCache?.removeAll()
    }

    func testStoreImage() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let image = UIImage()

        // When
        imageCache.store(image: image, with: url)

        // Then
        let key = CacheKey(url: url)
        XCTAssertTrue(imageCache.memoryCache.contains(forKey: key))

        let diskCache = try XCTUnwrap(imageCache.diskCache)
        XCTAssertTrue(diskCache.contains(forKey: key))
    }

    func testGetCachedImageFromMemoryCache() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let image = UIImage()

        // When
        imageCache.store(image: image, with: url)

        let key = CacheKey(url: url)
        imageCache.diskCache?.remove(forKey: key)
        let cachedImage = imageCache.cachedImage(by: url)

        // Then
        XCTAssertEqual(cachedImage, image)
    }

    func testGetCachedImageFromDiskCache() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let image = UIImage()

        // When
        imageCache.store(image: image, with: url)

        let key = CacheKey(url: url)
        imageCache.memoryCache.remove(forKey: key)
        let cachedImage = imageCache.cachedImage(by: url)

        // Then
        XCTAssertEqual(cachedImage, image)
    }

    func testHasCachedImage() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let image1 = UIImage()
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let image2 = UIImage()

        // When
        imageCache.store(image: image1, with: url1)
        imageCache.store(image: image2, with: url2)

        let result1 = imageCache.hasCachedImage(by: url1)
        let result2 = imageCache.hasCachedImage(by: url2)
        
        // Then
        XCTAssertTrue(result1)
        XCTAssertTrue(result2)
    }

    func testImageCacheCallCount() throws {
        // Given
        let memoryCache = MemoryCacheSpy()
        let diskCache = DiskCacheSpy()
        imageCache = ImageCache(memoryCache: memoryCache, diskCache: diskCache)

        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let image1 = UIImage()
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let image2 = UIImage()

        // When
        imageCache.store(image: image1, with: url1)
        imageCache.store(image: image2, with: url2)

        imageCache.remove(forKey: CacheKey(url: url1))
        imageCache.removeAll()

        // Then

        XCTAssertEqual(memoryCache.setValueCallCount, 2)
        XCTAssertEqual(memoryCache.removeCallCount, 1)
        XCTAssertEqual(memoryCache.removeAllCallCount, 1)
        XCTAssertEqual(diskCache.setValueCallCount, 2)
        XCTAssertEqual(diskCache.removeCallCount, 1)
        XCTAssertEqual(diskCache.removeAllCallCount, 1)
    }
}
