//
//  BaseTableViewHeaderFooterView.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView, ReuseIdentifiable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        // Override here
    }
}
