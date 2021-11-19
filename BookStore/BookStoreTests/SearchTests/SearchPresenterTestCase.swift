//
//  SearchPresenterTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation

import XCTest
@testable import BookStore

class SearchPresenterTestCase: XCTestCase {
    
    var presenter: SearchPresenter!
    var viewController: SearchViewControllerSpy!
    
    override func setUpWithError() throws {
        presenter = SearchPresenter()
        viewController = SearchViewControllerSpy()
        presenter.viewController = viewController
    }
    
    func testPresentSearchResultSuccess() throws {
        // Given
        let factory = BookSearchTestDataFactory()
        let searchResult = factory.makeSearchSuccessResponseTestData()
        var books: [BookSearchResult.Book] {
            guard case let .success(result) = searchResult else { return [] }
            return result.books
        }
        let response = SearchModel.Search.Response.result(books)
        
        // When
        presenter.presentSearchResult(response: response)
        
        // Then
        XCTAssertEqual(viewController.sectionsCount, 1)
        XCTAssertEqual(viewController.displayCallCount, 1)
        XCTAssertEqual(viewController.displayViewModelCallCount, 1)
        
        XCTAssertEqual(viewController.displayErrorAlertCallCount, 0)
    }
    
    func testPresentSearchResultError() throws {
        // Given
        let response = SearchModel.Search.Response.error(.searchError(message: ""))
        
        // When
        presenter.presentSearchResult(response: response)
        
        // Then
        XCTAssertEqual(viewController.displayCallCount, 1)
        XCTAssertEqual(viewController.displayErrorAlertCallCount, 1)
        
        XCTAssertEqual(viewController.sectionsCount, 0)
        XCTAssertEqual(viewController.displayViewModelCallCount, 0)
    }
    
    func testPresentISBNError() throws {
        // Given
        let response = SearchModel.Search.Response.error(.isbnError)
        
        // When
        presenter.presentSearchResult(response: response)
        
        // Then
        XCTAssertEqual(viewController.displayCallCount, 1)
        XCTAssertEqual(viewController.displayErrorAlertCallCount, 1)
        
        XCTAssertEqual(viewController.sectionsCount, 0)
        XCTAssertEqual(viewController.displayViewModelCallCount, 0)
    }
}
