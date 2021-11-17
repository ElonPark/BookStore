//
//  BaseImageView.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

class BaseImageView: UIImageView {

    override init(image: UIImage?) {
      super.init(image: image)
      initialize()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
      super.init(image: image, highlightedImage: highlightedImage)
      initialize()
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        // Override here
        translatesAutoresizingMaskIntoConstraints = false
    }
}
