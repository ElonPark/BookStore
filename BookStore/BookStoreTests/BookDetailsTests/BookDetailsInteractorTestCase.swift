//
//  BookDetailsInteractorTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import XCTest
@testable import BookStore

class BookDetailsInteractorTest: XCTestCase {

    var interactor: BookDetailsInteractor!
    var presenter: BookDetailsPresenterSpy!
    var router: BookDetailsRouterSpy!

    override func setUpWithError() throws {
        let state = BookDetailsModel.Details.State(isbn13: "9781617294136")
        let networkProvider = NetworkProvider<DetailsAPI>(stubClosure: NetworkProvider.immediatelyStub)
        let repository = BookDetailsRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13Validator()

        interactor = BookDetailsInteractor(
            initialState: state,
            bookDetailsRepository: repository,
            isbn13Validator: isbn13Validator
        )
        presenter = BookDetailsPresenterSpy()
        router = BookDetailsRouterSpy()

        interactor.presenter = presenter
        interactor.router = router
    }

    func testBookDetailsRequestWhenSuccess() throws {
        // Given
        let request = BookDetailsModel.Details.Request.bookDetails

        // When
        interactor.bookDetails(request: request)

        // Then
        XCTAssertEqual(presenter.presentBookDetailsCallCount, 1)
        XCTAssertEqual(presenter.resultCaseCallCount, 1)

        XCTAssertEqual(presenter.errorCaseCallCount, 0)
        XCTAssertEqual(presenter.resultErrorCallCount, 0)
        XCTAssertEqual(presenter.undefinedErrorCallCount, 0)
        XCTAssertEqual(presenter.urlErrorCallCount, 0)
    }

    func testBookDetailsRequestWhenISBN13IsInvalid() throws {
        // Given
        let state = BookDetailsModel.Details.State(isbn13: "0000000000000")
        let networkProvider = NetworkProvider<DetailsAPI>(stubClosure: NetworkProvider.immediatelyStub)
        let repository = BookDetailsRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13Validator()

        interactor = BookDetailsInteractor(
            initialState: state,
            bookDetailsRepository: repository,
            isbn13Validator: isbn13Validator
        )
        presenter = BookDetailsPresenterSpy()
        interactor.presenter = presenter

        let request = BookDetailsModel.Details.Request.bookDetails

        // When
        interactor.bookDetails(request: request)

        // Then
        XCTAssertEqual(presenter.presentBookDetailsCallCount, 1)
        XCTAssertEqual(presenter.errorCaseCallCount, 1)
        XCTAssertEqual(presenter.isbnErrorCallCount, 1)

        XCTAssertEqual(presenter.resultErrorCallCount, 0)
        XCTAssertEqual(presenter.undefinedErrorCallCount, 0)
        XCTAssertEqual(presenter.urlErrorCallCount, 0)
        XCTAssertEqual(presenter.resultCaseCallCount, 0)

        XCTAssertEqual(router.routeToSafariCallCount, 0)
    }

    func testBookDetailsRequestWhenErrorResponse() throws {
        // Given
        let state = BookDetailsModel.Details.State(isbn13: "9781617294136")
        let networkProvider = NetworkProvider<DetailsAPI>(
            endpointClosure: DetailsAPI.endpointErrorResponseClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookDetailsRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13Validator()

        interactor = BookDetailsInteractor(
            initialState: state,
            bookDetailsRepository: repository,
            isbn13Validator: isbn13Validator
        )
        presenter = BookDetailsPresenterSpy()
        interactor.presenter = presenter

        let request = BookDetailsModel.Details.Request.bookDetails

        // When
        interactor.bookDetails(request: request)

        // Then
        XCTAssertEqual(presenter.presentBookDetailsCallCount, 1)
        XCTAssertEqual(presenter.errorCaseCallCount, 1)
        XCTAssertEqual(presenter.resultErrorCallCount, 1)

        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.undefinedErrorCallCount, 0)
        XCTAssertEqual(presenter.urlErrorCallCount, 0)
        XCTAssertEqual(presenter.resultCaseCallCount, 0)

        XCTAssertEqual(router.routeToSafariCallCount, 0)
    }

    func testBookDetailsRequestWhenNetworkError() throws {
        // Given
        let state = BookDetailsModel.Details.State(isbn13: "9781617294136")
        let networkProvider = NetworkProvider<DetailsAPI>(
            endpointClosure: DetailsAPI.endpointNetworkErrorClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookDetailsRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13Validator()

        interactor = BookDetailsInteractor(
            initialState: state,
            bookDetailsRepository: repository,
            isbn13Validator: isbn13Validator
        )
        presenter = BookDetailsPresenterSpy()
        interactor.presenter = presenter

        let request = BookDetailsModel.Details.Request.bookDetails

        // When
        interactor.bookDetails(request: request)

        // Then
        XCTAssertEqual(presenter.presentBookDetailsCallCount, 1)
        XCTAssertEqual(presenter.errorCaseCallCount, 1)
        XCTAssertEqual(presenter.undefinedErrorCallCount, 1)

        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.resultErrorCallCount, 0)
        XCTAssertEqual(presenter.urlErrorCallCount, 0)
        XCTAssertEqual(presenter.resultCaseCallCount, 0)

        XCTAssertEqual(router.routeToSafariCallCount, 0)
    }

    func testRouteToSafari() throws {
        // Given
        let url = URL(string: "https://itbook.store/books/1001605784161")
        let request = BookDetailsModel.Details.Request.routeToSafari(url: url)

        // When
        interactor.bookDetails(request: request)

        // Then
        XCTAssertEqual(router.routeToSafariCallCount, 1)

        XCTAssertEqual(presenter.presentBookDetailsCallCount, 0)
        XCTAssertEqual(presenter.resultCaseCallCount, 0)
        XCTAssertEqual(presenter.errorCaseCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.resultErrorCallCount, 0)
        XCTAssertEqual(presenter.undefinedErrorCallCount, 0)
        XCTAssertEqual(presenter.urlErrorCallCount, 0)
    }

    func testBookDetailsRequestWhenURLError() throws {
        // Given
        let request = BookDetailsModel.Details.Request.routeToSafari(url: nil)

        // When
        interactor.bookDetails(request: request)

        // Then
        XCTAssertEqual(presenter.presentBookDetailsCallCount, 1)
        XCTAssertEqual(presenter.errorCaseCallCount, 1)
        XCTAssertEqual(presenter.urlErrorCallCount, 1)

        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.resultErrorCallCount, 0)
        XCTAssertEqual(presenter.resultCaseCallCount, 0)
        XCTAssertEqual(presenter.undefinedErrorCallCount, 0)

        XCTAssertEqual(router.routeToSafariCallCount, 0)
    }
}
