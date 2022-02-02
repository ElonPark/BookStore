//
//  KeyStore.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation

final class KeyStore: NSObject {
    private var keys = Set<CacheKey>()
    
    func insert(_ key: CacheKey) {
        keys.insert(key)
    }
    
    func remove(_ key: CacheKey) {
        keys.remove(key)
    }
    
    func contains(_ key: CacheKey) -> Bool {
        return keys.contains(key)
    }
}

extension KeyStore: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let imageContainer = obj as? ImageContainer else { return }
        remove(imageContainer.key)
    }
}
