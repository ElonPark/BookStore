//
//  ReuseIdentifiable.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import Foundation

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}
