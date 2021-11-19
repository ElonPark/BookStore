//
//  ISBN13ValidatorTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import BookStore

class ISBN13ValidatorTestCase: XCTestCase {
    
    var validator: ISBN13validating!
    
    override func setUpWithError() throws {
        validator = ISBN13Validator()
    }
    
    func testValidISBN13() throws {
        // Given
        let isbnList = [
            "978-1734314502",
            "9781734314502",
            "978-1788399081",
            "9781788399081",
            "978-1617294136",
            "9781617294136",
            "978-1-617-29413-6",
            "978 1 617 29413 6",
            "978-1785284700",
            "9781785284700",
            "978-0-596-52068-7",
            "978 0 596 52068 7",
            "9780596520687"
        ]
        
        // when
        let result = isbnList.filter { validator.isValid(isbn13: $0) }
        
        // Then
        XCTAssertEqual(result, isbnList)
    }
    
    func testInvalidISBN13() throws {
        // Given
        let isbnList = [
            "978-1734314509",
            "9781734314509",
            "978-1-734-31450-9",
            "978 1 734 31450 9",
            "978-1788399083",
            "9781788399083",
            "978-1-788-39908-3",
            "978 1 788 39908 3",
            "000-0000000000",
            "0000000000000",
            "000-0-000-00000-0",
            "000 0 000 00000 0",
            "test",
            "q1w2e3r4"
        ]
        
        // when
        let result = isbnList.filter { validator.isValid(isbn13: $0) }
        
        // Then
        XCTAssertEqual(result.count, 0)
    }
    
    func testFilteringISBN13() throws {
        let validISBNList = [
            "978-1734314502",
            "9781734314502",
            "978-1788399081",
            "9781788399081",
            "978-1617294136",
            "9781617294136",
            "978-1-617-29413-6",
            "978 1 617 29413 6",
            "978-1785284700",
            "9781785284700",
            "978-0-596-52068-7",
            "978 0 596 52068 7",
            "9780596520687"
        ]
        let invalidISBNList = [
            "978-1734314509",
            "9781734314509",
            "978-17343145",
            "978173431450",
            "97817343145",
            "978-1-734-31450-9",
            "978 1 734 31450 9",
            "978-1788399083",
            "9781788399083",
            "978-1-788-39908-3",
            "978 1 788 39908 3",
            "000-0000000000",
            "0000000000000",
            "000-0-000-00000-0",
            "000 0 000 00000 0",
            "test",
            "q1w2e3r4"
        ]
        
        var isbnList = validISBNList + invalidISBNList
        isbnList.shuffle()
        
        // when
        let result = isbnList.filter { validator.isValid(isbn13: $0) }
        
        // Then
        XCTAssertEqual(result.sorted(), validISBNList.sorted())
    }
}
