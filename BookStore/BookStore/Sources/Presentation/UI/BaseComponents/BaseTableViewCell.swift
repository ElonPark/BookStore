//
//  BaseTableViewCell.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

class BaseTableViewCell: UITableViewCell, ReuseIdentifiable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
