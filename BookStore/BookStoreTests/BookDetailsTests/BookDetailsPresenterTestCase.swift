//
//  BookDetailsPresenterTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import XCTest
@testable import BookStore

class BookDetailsPresenterTestCase: XCTestCase {
    
    var presenter: BookDetailsPresenter!
    var viewController: BookDetailsViewControllerSpy!
    
    override func setUpWithError() throws {
        presenter = BookDetailsPresenter()
        viewController = BookDetailsViewControllerSpy()
        presenter.viewController = viewController
    }
    
    func testBookDetailsSuccess() throws {
        // Given
        let factory = BookDetailsTestDataFactory()
        let detailsResult = factory.makeSuccessResponseTestData()
        var details: BookDetails.Details? {
            guard case let .success(result) = detailsResult else { return nil }
            return result
        }
        
        let result = try XCTUnwrap(details)
        let response = BookDetailsModel.Details.Response.result(result)
        
        // When
        presenter.presentBookDetails(response: response)
        
        // Then
        XCTAssertTrue(viewController.sectionsCount > 0)
        XCTAssertEqual(viewController.displayCallCount, 1)
        XCTAssertEqual(viewController.displayViewModelCallCount, 1)
        
        XCTAssertEqual(viewController.displayErrorAlertCallCount, 0)
    }
    
    func testBookDetailsError() throws {
        // Given
        let isbnErrorResponse = BookDetailsModel.Details.Response.error(.isbnError)
        let resultErrorResponse = BookDetailsModel.Details.Response.error(.resultError(""))
        let undefinedErrorResponse = BookDetailsModel.Details.Response.error(.undefinedError(""))
        let urlErrorResponse = BookDetailsModel.Details.Response.error(.urlError(""))
        
        // When
        presenter.presentBookDetails(response: isbnErrorResponse)
        presenter.presentBookDetails(response: resultErrorResponse)
        presenter.presentBookDetails(response: undefinedErrorResponse)
        presenter.presentBookDetails(response: urlErrorResponse)
        
        // Then
        XCTAssertEqual(viewController.displayCallCount, 4)
        XCTAssertEqual(viewController.displayErrorAlertCallCount, 4)
        
        XCTAssertEqual(viewController.sectionsCount, 0)
        XCTAssertEqual(viewController.displayViewModelCallCount, 0)
    }
}
