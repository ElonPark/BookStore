//
//  ImageDownloaderTestCase.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import ImageDownloader

class ImageDownloaderTestcase: XCTestCase {

    var imageDownloader: ImageDownloader!

    override func setUpWithError() throws {
        imageDownloader = ImageDownloader()
    }

    override func tearDownWithError() throws {
        ImageDownloader.shared.cache.removeAll()
    }

    func testLoadImage() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!

        // When
        var downloadImage: UIImage?
        var downloadError: Error?
        let expectation = XCTestExpectation(description: "loadImage timeout")

        imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage = image
            case let .failure(error):
                downloadError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        // Then
        XCTAssertNotNil(downloadImage)
        XCTAssertNil(downloadError)
    }

    func testLoadImageError() throws {
        // Given
        let url = URL(string: "test")!

        // When
        var downloadImage: UIImage?
        var downloadError: Error?
        let expectation = XCTestExpectation(description: "loadImage timeout")

        imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage = image
            case let .failure(error):
                downloadError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        // Then
        XCTAssertNil(downloadImage)
        XCTAssertNotNil(downloadError)
    }

    func testCancelLoadImage() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!

        // When
        var downloadImage: UIImage?
        var downloadError: Error?
        let expectation = XCTestExpectation(description: "loadImage timeout")

        let requst = imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage = image
            case let .failure(error):
                downloadError = error
            }
            expectation.fulfill()
        }
        requst?.cancel()

        wait(for: [expectation], timeout: 4.0)

        // Then
        XCTAssertNil(downloadImage)
        XCTAssertNotNil(downloadError)

        let isExplicitlyCancelledError = try XCTUnwrap(downloadError?.asAFError?.isExplicitlyCancelledError)
        XCTAssertTrue(isExplicitlyCancelledError)
    }

    func testLoadImageStoreCache() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9781098118501.png")!

        // When
        var downloadImage: UIImage?
        var downloadError: Error?
        var cachedImage: UIImage?
        let expectation = XCTestExpectation(description: "loadImage timeout")

        imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage = image
            case let .failure(error):
                downloadError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)
        cachedImage = imageDownloader.cache.cachedImage(by: url)

        // Then
        XCTAssertNotNil(downloadImage)
        XCTAssertNotNil(cachedImage)
        XCTAssertNil(downloadError)
    }

    /// 처음 이미지 다운로드 후 두번째 요청시에는 캐시를 사용하기 때문에 request2는 생성되지 않는다.
    func testLoadImageReturnCachedImage() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9781491999318.png")!

        // When
        var downloadImage1: UIImage?
        var downloadError1: Error?
        var downloadImage2: UIImage?
        var downloadError2: Error?
        let expectation1 = XCTestExpectation(description: "loadImage1 timeout")
        let expectation2 = XCTestExpectation(description: "loadImage2 timeout")

        let request1 = imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage1 = image
            case let .failure(error):
                downloadError1 = error
            }
            expectation1.fulfill()
        }

        wait(for: [expectation1], timeout: 4.0)

        let request2 = imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage2 = image
            case let .failure(error):
                downloadError2 = error
            }
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 4.0)

        // Then
        XCTAssertNotNil(request1)
        XCTAssertNotNil(downloadImage1)
        XCTAssertNil(downloadError1)

        XCTAssertNil(request2)
        XCTAssertNotNil(downloadImage2)
        XCTAssertNil(downloadError2)
    }

    func testLoadImageRemoveCachedImage() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9781491900826.png")!

        // When
        var downloadImage1: UIImage?
        var downloadError1: Error?
        var downloadImage2: UIImage?
        var downloadError2: Error?
        let expectation1 = XCTestExpectation(description: "loadImage1 timeout")
        let expectation2 = XCTestExpectation(description: "loadImage2 timeout")

        let request1 = imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage1 = image
            case let .failure(error):
                downloadError1 = error
            }
            expectation1.fulfill()
        }

        wait(for: [expectation1], timeout: 4.0)
        imageDownloader.cache.remove(forKey: CacheKey(url: url))

        let request2 = imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage2 = image
            case let .failure(error):
                downloadError2 = error
            }
            expectation2.fulfill()
        }

        wait(for: [expectation2], timeout: 4.0)

        // Then
        XCTAssertNotNil(request1)
        XCTAssertNotNil(downloadImage1)
        XCTAssertNil(downloadError1)

        XCTAssertNotNil(request2)
        XCTAssertNotNil(downloadImage2)
        XCTAssertNil(downloadError2)
    }

    func testLoadImageCacheCallCount() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/9780983066989.png")!
        let cache = ImageCachingSpy(memoryCache: MemoryCacheSpy(), diskCache: DiskCacheSpy())
        let imageDownloader = ImageDownloader(cache: cache)

        // When
        var downloadImage: UIImage?
        var downloadError: Error?
        let expectation = XCTestExpectation(description: "loadImage timeout")

        imageDownloader.loadImage(with: url) { result in
            switch result {
            case let .success(image):
                downloadImage = image
            case let .failure(error):
                downloadError = error
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        // Then
        XCTAssertNotNil(downloadImage)
        XCTAssertNil(downloadError)
        XCTAssertEqual(cache.cachedImageCallCount, 1)
        XCTAssertEqual(cache.hasCachedImageCallCount, 1)
        XCTAssertEqual(cache.storeImageCallCount, 1)
    }

    func testCleaningCache() throws {
        // Given
        let cleaner = DiskCacheCleaner()
        cleaner.maxCapacity = 0
        let diskCache = try DiskCache(cleaner: cleaner, initialCleaningInterval: .seconds(2))
        let imageCache = ImageCache(diskCache: diskCache)
        imageDownloader = ImageDownloader(cache: imageCache)

        let url1 = URL(string: "https://itbook.store/img/books/9781491999318.png")!
        let url2 = URL(string: "https://itbook.store/img/books/1001605784161.png")!

        var downloadImage1: UIImage?
        var downloadImage2: UIImage?
        var downloadError1: Error?
        var downloadError2: Error?
        let expectation1 = XCTestExpectation(description: "loadImage1 timeout")
        let expectation2 = XCTestExpectation(description: "loadImage2 timeout")
        let waitExpectation = expectation(description: "Waiting")

        // When
        let request1 = imageDownloader.loadImage(with: url1) { result in
            switch result {
            case let .success(image):
                downloadImage1 = image
            case let .failure(error):
                downloadError1 = error
            }
            expectation1.fulfill()
        }

        let request2 = imageDownloader.loadImage(with: url2) { result in
            switch result {
            case let .success(image):
                downloadImage2 = image
            case let .failure(error):
                downloadError2 = error
            }
            expectation2.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            waitExpectation.fulfill()
        }
        wait(for: [expectation1, expectation2, waitExpectation], timeout: 2.5)

        // Then
        XCTAssertNotNil(request1)
        XCTAssertNotNil(request2)
        XCTAssertNotNil(downloadImage1)
        XCTAssertNotNil(downloadImage2)
        XCTAssertNil(downloadError1)
        XCTAssertNil(downloadError2)

        XCTAssertEqual(diskCache.totalCacheSize, 0)
    }
}
