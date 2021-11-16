//
//  BookDetailsRepositoryStubTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/17.
//

import XCTest
@testable import BookStore

class BookDetailsRepositoryStubTestCase: XCTestCase {

  var bookDetailsRepository: BookDetailsRepository!

  override func setUpWithError() throws {
    let provider = NetworkProvider<DetailsAPI>(stubClosure: NetworkProvider.delayedStub(0.5))
    bookDetailsRepository = BookDetailsRepositoryImpl(networkProvider: provider)
  }

  func testBookDetailsSuccessResponse() throws {
    // Given
    let isbn = "9781617294136"

    // when
    var bookDetails: BookDetails?
    var bookDetailsError: Error?
    let expectation = XCTestExpectation()

    let testDataFactory = BookDetailsTestDataFactory()
    let expectResult = testDataFactory.makeSuccessResponseTestData()

    bookDetailsRepository.bookDetails(isbn13: isbn) { response in
      switch response {
      case let .success(result):
        bookDetails = result

      case let .failure(error):
        bookDetailsError = error
      }

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)

    // Then
    let result = try XCTUnwrap(bookDetails)
    XCTAssertEqual(result, expectResult)
    XCTAssertNil(bookDetailsError)
  }

  /// Test when invalid ISBN
  func testBookDetailsErrorResponse() throws {
    // Given
    let testISBN = "0000000000000"

    let provider = NetworkProvider<DetailsAPI>(
        endpointClosure: DetailsAPI.endpointErrorResponseClosure,
        stubClosure: NetworkProvider.delayedStub(0.5)
    )
    bookDetailsRepository = BookDetailsRepositoryImpl(networkProvider: provider)

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

    wait(for: [expectation], timeout: 1.0)

    // Then
    let result = try XCTUnwrap(bookDetails)
    XCTAssertEqual(result, expectResult)
    XCTAssertNil(bookDetailsError)
  }
}
