//
//  BookDetailsRepositoryTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import BookStore

import Moya

class BookDetailsRepositoryTestCase: XCTestCase {

  var bookDetailsRepository: BookDetailsRepository!

  override func setUpWithError() throws {
    bookDetailsRepository = BookDetailsRepositoryImpl(networkProvider: NetworkProvider())
  }

  func testBookDetailsSuccessResponse() throws {
    // Given
    let isbn = "9781617294136"

    // when
    var bookDetails: BookDetails?
    var bookDetailsError: Error?
    let expectation = XCTestExpectation()

    bookDetailsRepository.bookDetails(isbn13: isbn) { response in
      switch response {
      case let .success(result):
        bookDetails = result

      case let .failure(error):
        bookDetailsError = error
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 4.0)

    // Then
    XCTAssertNotNil(bookDetails)
    XCTAssertNil(bookDetailsError)
  }

  /// Test when invalid ISBN
  func testBookDetailsErrorResponse() throws {
    // Given
    let testISBN = "0000000000000"

    // when
    var bookDetails: BookDetails?
    var bookDetailsError: Error?
    let expectation = XCTestExpectation()

    let testDataFactory = BookDetailsTestDataFactory()
    let expectResult = testDataFactory.makeErrorResponseTestData()

    bookDetailsRepository.bookDetails(isbn13: testISBN) { response in
      switch response {
      case let .success(result):
        bookDetails = result

      case let .failure(error):
        bookDetailsError = error
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 4.0)

    // Then
    let result = try XCTUnwrap(bookDetails)
    XCTAssertEqual(result, expectResult)
    XCTAssertNil(bookDetailsError)
  }

  /// Test when invalid format ISBN
  func testBookDetailsErrorResponseWhenInvalidFormatISBN() throws {
    // Given
    let testISBN = "9781734314509"

    // when
    var bookDetails: BookDetails?
    var bookDetailsError: Error?
    let expectation = XCTestExpectation()

    let testDataFactory = BookDetailsTestDataFactory()
    let expectResult = testDataFactory.makeErrorResponseTestData()

    bookDetailsRepository.bookDetails(isbn13: testISBN) { response in
      switch response {
      case let .success(result):
        bookDetails = result

      case let .failure(error):
        bookDetailsError = error
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 4.0)

    // Then
    let result = try XCTUnwrap(bookDetails)
    XCTAssertEqual(result, expectResult)
    XCTAssertNil(bookDetailsError)
  }

  /// Test when invalid format ISBN
  func testBookDetailsFailure() throws {
    // Given
    let invalidISBN = "1234"

    // when
    var bookDetails: BookDetails?
    var bookDetailsError: Error?
    let expectation = XCTestExpectation()

    bookDetailsRepository.bookDetails(isbn13: invalidISBN) { response in
      switch response {
      case let .success(result):
        bookDetails = result

      case let .failure(error):
        bookDetailsError = error
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 4.0)

    // Then
    XCTAssertNil(bookDetails)
    XCTAssertNotNil(bookDetailsError)

    let moyaError = try XCTUnwrap(bookDetailsError as? MoyaError)
    let statusCode = try XCTUnwrap(moyaError.response?.statusCode)
    XCTAssertEqual(statusCode, 404)
  }
}
