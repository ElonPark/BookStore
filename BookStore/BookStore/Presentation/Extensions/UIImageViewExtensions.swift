//
//  UIImageViewExtensions.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

import ImageDownloader

extension UIImageView {

  @discardableResult
  func setImage(with urlString: String) -> ImageDownloadCancelable? {
    return setImage(with: URL(string: urlString))
  }

  @discardableResult
  func setImage(with imageURL: URL?) -> ImageDownloadCancelable? {
    guard let url = imageURL else { return nil }
    return ImageDownloader.shared.loadImage(with: url) { [weak self] result in
      switch result {
      case let .success(image):
        self?.image = image

      case .failure:
        break
      }
    }
  }
}
