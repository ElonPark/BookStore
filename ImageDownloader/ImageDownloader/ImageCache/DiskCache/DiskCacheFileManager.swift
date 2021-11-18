//
//  DiskCacheFileManager.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation

final class DiskCacheFileManager {
    
    private let directoryPath: URL
    
    init(directoryName: String) throws {
        directoryPath = try Self.cachesDirectoryURL(withName: directoryName)
    }
    
    static func cachesDirectoryURL(withName directoryName: String) throws -> URL {
        let directoryURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let cachesDirectory = directoryURLs.first else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil)
        }
        
        return cachesDirectory.appendingPathComponent(directoryName, isDirectory: true)
    }
    
    func createDirectory() throws {
        try FileManager.default.createDirectory(
            at: directoryPath,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    func contains(with url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func writeToDisk(_ imageContainer: ImageContainer, to url: URL) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: imageContainer, requiringSecureCoding: false)
            try data.write(to: url)
            
        } catch let error as NSError {
            print(error)
            
            let isNoSuchFileError = error.code == CocoaError.fileNoSuchFile.rawValue
            let isCocoaErrorDomain = error.domain == CocoaError.errorDomain
            guard isNoSuchFileError && isCocoaErrorDomain else { return }
            
            try? createDirectory()
            let data = try? NSKeyedArchiver.archivedData(withRootObject: imageContainer, requiringSecureCoding: false)
            try? data?.write(to: url)
        }
    }
    
    func readFromDisk(with url: URL) -> ImageContainer? {
        do {
            let data = try Data(contentsOf: url)
            
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            
            let unarchivedObject = unarchiver.decodeObject(
                of: [ImageContainer.classForCoder()],
                forKey: NSKeyedArchiveRootObjectKey
            )
            return unarchivedObject as? ImageContainer
            
        } catch {
            print(error)
            return nil
        }
    }
    
    func removeFromDisk(with url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    func removeAllFromDisk() {
        do {
            try FileManager.default.removeItem(at: directoryPath)
            try createDirectory()
        } catch {
            print(error)
        }
    }
    
    func url(byFilename filename: String) -> URL? {
        return directoryPath.appendingPathComponent(filename, isDirectory: false)
    }
    
    func diskItemIndices(by urlResourceKeys: [URLResourceKey]) -> [DiskItemIndex] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(
                at: directoryPath,
                includingPropertiesForKeys: urlResourceKeys,
                options: [.skipsHiddenFiles]
            )
            
            let keys = Set(urlResourceKeys)
            let indices: [DiskItemIndex] = urls.compactMap {
                guard let metadata = try? $0.resourceValues(forKeys: keys) else { return nil }
                return DiskItemIndex(url: $0, metadata: metadata)
            }
            
            return indices
            
        } catch {
            print(error)
            return []
        }
    }
}
