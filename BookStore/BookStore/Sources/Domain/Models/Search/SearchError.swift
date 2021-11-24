//
//  SearchError.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import Foundation

enum BookSearchError: Error {
    case searchError(message: String)
    case isbnError
}
