//
//  ISBN13Validator.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import Foundation

protocol ISBN13validating {
    func isValid(isbn13: String) -> Bool
}

struct ISBN13Validator: ISBN13validating {
    func isValid(isbn13: String) -> Bool {
        guard !isbn13.isEmpty else { return false }

        let isbnNumbers = isbn13.compactMap { $0.wholeNumberValue }
        guard isbnNumbers.count == 13 else { return false}

        let total = isbnNumbers.reduce(0, +)
        guard total > 0 else { return false }

        let sum = isbnNumbers
            .enumerated()
            .map { $0.offset & 1 == 1 ? 3 * $0.element : $0.element }
            .reduce(0, +)

        return sum % 10 == 0
    }
}
