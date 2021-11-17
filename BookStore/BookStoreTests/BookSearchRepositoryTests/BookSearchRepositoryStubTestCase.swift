//
//  BookSearchRepositoryStubTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/17.
//


import XCTest
@testable import BookStore

class BookSearchRepositoryStubTestCase: XCTestCase {

    var bookSearchRepository: BookSearchRepository!

    override func setUpWithError() throws {
        let provider = NetworkProvider<SearchAPI>(stubClosure: NetworkProvider.delayedStub(0.5))
        bookSearchRepository = BookSearchRepositoryImpl(networkProvider: provider)
    }

    // MARK: - Search Test

    func testBookSearchSuccessResponse() throws {
        // Given
        let keyword = "swift"

        // when
        var bookSearchResult: BookSearchResult?
        var bookSearchResultError: Error?
        let expectation = XCTestExpectation()

        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchSuccessResponseTestData()

        bookSearchRepository.search(byKeyword: keyword) { response in
            switch response {
            case let .success(result):
                bookSearchResult = result

            case let .failure(error):
                bookSearchResultError = error
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        // Then
        let result = try XCTUnwrap(bookSearchResult)
        XCTAssertEqual(result, expectResult)
        XCTAssertNil(bookSearchResultError)
    }

    func testBookSearchErrorResponse() throws {
        // Given
        let keyword = ""

        let provider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointErrorResponseClosure,
            stubClosure: NetworkProvider.delayedStub(0.5)
        )
        bookSearchRepository = BookSearchRepositoryImpl(networkProvider: provider)

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

        wait(for: [expectation], timeout: 1.0)

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
        var bookSearchResultError: Error?
        let expectation = XCTestExpectation()

        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchWithPaginationSuccessResponseTestData()

        bookSearchRepository.search(byKeyword: keyword, withPagination: page) { response in
            switch response {
            case let .success(result):
                bookSearchResult = result

            case let .failure(error):
                bookSearchResultError = error
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        // Then
        let result = try XCTUnwrap(bookSearchResult)
        XCTAssertEqual(result, expectResult)
        XCTAssertNil(bookSearchResultError)
    }

    func testBookSearchWithPaginationErrorResponse() throws {
        // Given
        let keyword = ""
        let page = 0

        let provider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointErrorResponseClosure,
            stubClosure: NetworkProvider.delayedStub(0.5)
        )
        bookSearchRepository = BookSearchRepositoryImpl(networkProvider: provider)

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

        wait(for: [expectation], timeout: 1.0)

        // Then
        let result = try XCTUnwrap(bookSearchResult)
        XCTAssertEqual(result, expectResult)
        XCTAssertNil(bookSearchResultError)
    }
}
