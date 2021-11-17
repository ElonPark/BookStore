//
//  BookSearchRepositoryTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import BookStore

import Moya

class BookSearchRepositoryTestCase: XCTestCase {

    var bookSearchRepository: BookSearchRepository!

    override func setUpWithError() throws {
        bookSearchRepository = BookSearchRepositoryImpl(networkProvider: NetworkProvider())
    }

    // MARK: - Search Test

    func testBookSearchSuccessResponse() throws {
        // Given
        let keyword = "swift"

        // when
        var bookSearchResult: BookSearchResult?
        var bookSearchResultError: Error?
        let expectation = XCTestExpectation()

        bookSearchRepository.search(byKeyword: keyword) { response in
            switch response {
            case let .success(result):
                bookSearchResult = result

            case let .failure(error):
                bookSearchResultError = error
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        // Then
        XCTAssertNotNil(bookSearchResult)
        XCTAssertNil(bookSearchResultError)
    }

    func testBookSearchErrorResponse() throws {
        // Given
        let keyword = ""

        // when
        var bookSearchResult: BookSearchResult?
        var bookSearchResultError: Error?
        let expectation = XCTestExpectation()

        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchErrorResponseTestData()

        bookSearchRepository.search(byKeyword: keyword) { response in
            switch response {
            case let .success(result):
                bookSearchResult = result

            case let .failure(error):
                bookSearchResultError = error
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        // Then
        let result = try XCTUnwrap(bookSearchResult)
        XCTAssertEqual(result, expectResult)
        XCTAssertNil(bookSearchResultError)
    }

    // MARK: - Search with pagination Test

    func testBookSearchWithPaginationSuccessResponse() throws {
        // Given
        let keyword = "swift"
        let page = 2

        // when
        var bookSearchResult: BookSearchResult?
        var bookSearchResultPage: Int?
        var bookSearchResultError: Error?
        let expectation = XCTestExpectation()

        bookSearchRepository.search(byKeyword: keyword, withPagination: page) { response in
            switch response {
            case let .success(result):
                bookSearchResult = result

            case let .failure(error):
                bookSearchResultError = error
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        if case let .success(result) = bookSearchResult {
            bookSearchResultPage = result.page
        }

        // Then
        let resultPage = try XCTUnwrap(bookSearchResultPage)
        XCTAssertEqual(resultPage, 2)
        XCTAssertNil(bookSearchResultError)
    }

    func testBookSearchWithPaginationErrorResponse() throws {
        // Given
        let keyword = ""
        let page = 0

        // when
        var bookSearchResult: BookSearchResult?
        var bookSearchResultError: Error?
        let expectation = XCTestExpectation()

        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchErrorResponseTestData()

        bookSearchRepository.search(byKeyword: keyword, withPagination: page) { response in
            switch response {
            case let .success(result):
                bookSearchResult = result

            case let .failure(error):
                bookSearchResultError = error
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4.0)

        // Then
        let result = try XCTUnwrap(bookSearchResult)
        XCTAssertEqual(result, expectResult)
        XCTAssertNil(bookSearchResultError)
    }
}
