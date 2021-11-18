//
//  CacheKey.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation

final class CacheKey: NSObject {
    
    let url: URL
    let key: String
    
    init(url: URL) {
        self.url = url
        key = String(url.absoluteString.hashValue)
    }
    
    init?(coder: NSCoder) {
        guard let url: URL = Self.decodeObject(coder, forKey: .url),
              let key: String = Self.decodeObject(coder, forKey: .key)
        else { return nil }
        
        self.key = key
        self.url = url
    }
    
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(key)
        return hasher.finalize()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CacheKey else { return false }
        return key.hashValue == other.hashValue
    }
}

extension CacheKey: NSCoding {
    
    private enum CodingKey: String {
        case url = "url"
        case key = "key"
    }
    
    func encode(with coder: NSCoder) {
        encode(url, with: coder, forKey: .url)
        encode(key, with: coder, forKey: .key)
    }
    
    private func encode(_ object: Any, with coder: NSCoder, forKey key: CodingKey) {
        coder.encode(object, forKey: key.rawValue)
    }
    
    private static func decodeObject<T>(_ coder: NSCoder, forKey key: CodingKey) -> T? {
        return coder.decodeObject(forKey: key.rawValue) as? T
    }
}
