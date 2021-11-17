//
//  MemoryCache.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation
import UIKit

protocol MemoryCaching {
    var totalCostLimit: Int { get set }
    
    subscript(key: CacheKey) -> ImageContainer? { get set }
    func contains(forKey key: CacheKey) -> Bool
    func value(forKey key: CacheKey) -> ImageContainer?
    func setValue(_ imageContainer: ImageContainer, forKey key: CacheKey)
    func remove(forKey key: CacheKey)
    func removeAll()
}

extension MemoryCaching {
    subscript(key: CacheKey) -> ImageContainer? {
        get {
            return value(forKey: key)
        }
        set {
            if let imageContainer = newValue {
                setValue(imageContainer, forKey: key)
            } else {
                remove(forKey: key)
            }
        }
    }
}

public final class MemoryCache: MemoryCaching {
    
    private let keyStore = KeyStore()
    private let cache = NSCache<CacheKey, ImageContainer>()
    
    var totalCostLimit: Int = 128 * 1024 * 1024 {
        didSet {
            cache.totalCostLimit = totalCostLimit
        }
    }
    
    init() {
        cache.delegate = self.keyStore
        cache.totalCostLimit = totalCostLimit
        observeMemoryWarning()
    }
    
    func contains(forKey key: CacheKey) -> Bool {
        return keyStore.contains(key)
    }
    
    func value(forKey key: CacheKey) -> ImageContainer? {
        return cache.object(forKey: key)
    }
    
    func setValue(_ imageContainer: ImageContainer, forKey key: CacheKey) {
        cache.setObject(imageContainer, forKey: key)
        keyStore.insert(key)
    }
    
    func remove(forKey key: CacheKey) {
        cache.removeObject(forKey: key)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
    
    private func observeMemoryWarning() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveMemoryWarningNotification),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc func didReceiveMemoryWarningNotification(_ notification: Notification) {
        removeAll()
    }
}
