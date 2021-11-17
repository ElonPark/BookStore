//
//  ImageContainer.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation
import UIKit

final class ImageContainer: NSObject {

    let key: CacheKey
    let image: UIImage

    init(key: CacheKey, image: UIImage) {
        self.key = key
        self.image = image
    }

    init?(coder: NSCoder) {
        guard let key: CacheKey = Self.decodeObject(coder, forKey: .key),
              let image: UIImage = Self.decodeObject(coder, forKey: .image)
        else { return nil }

        self.key = key
        self.image = image
    }

    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(key)
        hasher.combine(image)
        return hasher.finalize()
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ImageContainer else { return false }
        return key == other.key && image == other.image
    }
}

extension ImageContainer: NSCoding {

    private enum CodingKey: String {
        case key = "key"
        case image = "image"
    }

    func encode(with coder: NSCoder) {
        encode(key, with: coder, forKey: .key)
        encode(image, with: coder, forKey: .image)
    }

    private func encode(_ object: Any, with coder: NSCoder, forKey key: CodingKey) {
        coder.encode(object, forKey: key.rawValue)
    }

    private static func decodeObject<T>(_ coder: NSCoder, forKey key: CodingKey) -> T? {
        return coder.decodeObject(forKey: key.rawValue) as? T
    }
}
