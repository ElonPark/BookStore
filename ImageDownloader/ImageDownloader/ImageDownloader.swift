//
//  ImageDownloader.swift
//  ImageDownloader
//
//  Created by Elon on 2021/11/17.
//

import Foundation
import UIKit

import Alamofire

public final class ImageDownloader {

    public static var shared = ImageDownloader()

    let cache: ImageCaching

    init(cache: ImageCaching = ImageCache()) {
        self.cache = cache
    }

    @discardableResult
    public func loadImage(
        with url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> ImageDownloadCancelable? {
        if let cachedImage = self.cachedImage(by: url) {
            completion(.success(cachedImage))
            return nil
        }

        let session = AF.download(url)
            .responseData { [weak self] response in
                switch response.result {
                case let .success(data):
                    if let image = self?.processingImage(from: data, with: url) {
                        completion(.success(image))
                    } else {
                        completion(.failure(URLError(.cannotDecodeContentData)))
                    }

                case let .failure(error):
                    completion(.failure(error))
                }
            }

        return session
    }

    private func processingImage(from data: Data, with url: URL) -> UIImage? {
        guard let image = UIImage(data: data) else { return nil }
        cache.store(image: image, with: url)
        return image
    }

    private func cachedImage(by url: URL) -> UIImage? {
        guard cache.hasCachedImage(by: url) else { return nil }
        return cache.cachedImage(by: url)
    }
}
