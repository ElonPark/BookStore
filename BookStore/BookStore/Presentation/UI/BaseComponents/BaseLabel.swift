//
//  BaseLabel.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

class BaseLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        // Override here
        translatesAutoresizingMaskIntoConstraints = false
    }
}
