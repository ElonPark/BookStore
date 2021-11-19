//
//  ISBN13ValidatorFake.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation
@testable import BookStore

struct ISBN13ValidatorFake: ISBN13validating {
    func isValid(isbn13: String) -> Bool {
        return true
    }
}
