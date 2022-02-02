//
//  DiskCacheFileManagerTestCase.swift
//  ImageDownloaderTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import ImageDownloader

class DiskCacheFileManagerTest: XCTestCase {
    
    var diskCacheFileManager: DiskCacheFileManager!
    let directoryName = "com.elonparks.ImageDownloader.diskCache"
    var directoryPath: URL!
    
    override func setUpWithError() throws {
        diskCacheFileManager = try DiskCacheFileManager(directoryName: directoryName)
        
        let directoryURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let cachesDirectory = directoryURLs.first else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil)
        }
        
        directoryPath = cachesDirectory.appendingPathComponent(directoryName, isDirectory: true)
        try diskCacheFileManager.createDirectory()
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: directoryPath)
    }
    
    func testCreateDirectory() throws {
        // Given
        let directoryURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let url = directoryURLs[0].appendingPathComponent(directoryName, isDirectory: true)
        let path = url.path
        
        // When
        try FileManager.default.removeItem(at: url)
        try diskCacheFileManager.createDirectory()
        var isDirectory = ObjCBool(true)
        let isFileExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        
        // Then
        XCTAssertTrue(isFileExists)
    }
    
    func testFileURL() throws {
        // Given
        let url = URL(string: "https://itbook.store/img/books/1.png")!
        
        // When
        let fileURL = diskCacheFileManager.url(byFilename: url.path)
        
        // Then
        XCTAssertNotNil(fileURL)
    }
    
    func testWriteToDisk() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        let fileURL1 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url1.hashValue)))
        let fileURL2 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url2.hashValue)))
        diskCacheFileManager.writeToDisk(imageContainer1, to: fileURL1)
        diskCacheFileManager.writeToDisk(imageContainer2, to: fileURL2)
        
        // Then
        let isFileExists1 = FileManager.default.fileExists(atPath: fileURL1.path)
        XCTAssertTrue(isFileExists1)
        
        let isFileExists2 = FileManager.default.fileExists(atPath: fileURL2.path)
        XCTAssertTrue(isFileExists2)
    }
    
    func testReadToDisk() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        try diskCacheFileManager.createDirectory()
        
        let fileURL1 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url1.hashValue)))
        let fileURL2 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url2.hashValue)))
        diskCacheFileManager.writeToDisk(imageContainer1, to: fileURL1)
        diskCacheFileManager.writeToDisk(imageContainer2, to: fileURL2)
        
        let savedImageContainer1 = diskCacheFileManager.readFromDisk(with: fileURL1)
        let savedImageContainer2 = diskCacheFileManager.readFromDisk(with: fileURL2)
        
        // Then
        let result1 = try XCTUnwrap(savedImageContainer1)
        XCTAssertEqual(result1, imageContainer1)
        
        let result2 = try XCTUnwrap(savedImageContainer2)
        XCTAssertEqual(result2, imageContainer2)
    }
    
    func testContainsFile() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        let fileURL1 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url1.hashValue)))
        let fileURL2 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url2.hashValue)))
        diskCacheFileManager.writeToDisk(imageContainer1, to: fileURL1)
        diskCacheFileManager.writeToDisk(imageContainer2, to: fileURL2)
        
        let isFileExists1 = diskCacheFileManager.contains(with: fileURL1)
        let isFileExists2 = diskCacheFileManager.contains(with: fileURL2)
        
        // Then
        XCTAssertTrue(isFileExists1)
        XCTAssertTrue(isFileExists2)
    }
    
    func testRemoveFromDisk() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        let fileURL1 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url1.hashValue)))
        let fileURL2 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url2.hashValue)))
        diskCacheFileManager.writeToDisk(imageContainer1, to: fileURL1)
        diskCacheFileManager.writeToDisk(imageContainer2, to: fileURL2)
        
        diskCacheFileManager.removeFromDisk(with: fileURL1)
        diskCacheFileManager.removeFromDisk(with: fileURL2)
        
        // Then
        let isFileExists1 = diskCacheFileManager.contains(with: fileURL1)
        let isFileExists2 = diskCacheFileManager.contains(with: fileURL2)
        XCTAssertFalse(isFileExists1)
        XCTAssertFalse(isFileExists2)
    }
    
    func testRemoveAllFromDisk() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        let fileURL1 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url1.hashValue)))
        let fileURL2 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url2.hashValue)))
        diskCacheFileManager.writeToDisk(imageContainer1, to: fileURL1)
        diskCacheFileManager.writeToDisk(imageContainer2, to: fileURL2)
        
        diskCacheFileManager.removeAllFromDisk()
        
        // Then
        let isFileExists1 = diskCacheFileManager.contains(with: fileURL1)
        let isFileExists2 = diskCacheFileManager.contains(with: fileURL2)
        XCTAssertFalse(isFileExists1)
        XCTAssertFalse(isFileExists2)
    }
    
    func testDiskItemIndices() throws {
        // Given
        let url1 = URL(string: "https://itbook.store/img/books/testDiskItemIndices1.png")!
        let imageContainer1 = ImageContainer(key: CacheKey(url: url1), image: UIImage())
        
        let url2 = URL(string: "https://itbook.store/img/books/testDiskItemIndices2.png")!
        let imageContainer2 = ImageContainer(key: CacheKey(url: url2), image: UIImage())
        
        // When
        let fileURL1 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url1.hashValue)))
        let fileURL2 = try XCTUnwrap(diskCacheFileManager.url(byFilename: String(url2.hashValue)))
        diskCacheFileManager.writeToDisk(imageContainer1, to: fileURL1)
        diskCacheFileManager.writeToDisk(imageContainer2, to: fileURL2)
        
        let items = diskCacheFileManager.diskItemIndices(by: [.creationDateKey, .fileSizeKey])
        
        // Then
        XCTAssertEqual(items.count, 2)
        
        let hasFile1 = items.contains { $0.url == fileURL1 }
        XCTAssertTrue(hasFile1)
        XCTAssertNotNil(items[0].metadata.creationDate)
        XCTAssertNotNil(items[0].metadata.fileSize)
        
        let hasFile2 = items.contains { $0.url == fileURL2 }
        XCTAssertTrue(hasFile2)
        XCTAssertNotNil(items[1].metadata.creationDate)
        XCTAssertNotNil(items[1].metadata.fileSize)
    }
}
