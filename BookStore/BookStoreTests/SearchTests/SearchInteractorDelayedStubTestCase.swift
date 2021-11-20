//
//  SearchInteractorDelayedStubTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/20.
//


import XCTest
@testable import BookStore

class SearchInteractorDelayedStubTestCase: XCTestCase {

    var interactor: SearchInteractor!
    var presenter: SearchPresenterSpy!
    var router: SearchRouterSpy!

    override func setUpWithError() throws {
        let state = SearchModel.Search.State()
        let networkProvider = NetworkProvider<SearchAPI>(stubClosure: NetworkProvider.delayedStub(0.1))
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13ValidatorFake()
        presenter = SearchPresenterSpy()
        router = SearchRouterSpy()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter
        interactor.router = router
    }

    func testCancelFirstSearchRequestWhenSecondSearchRequestIsIncoming() throws {
        // Given
        let keyword1 = "swif"
        let keyword2 = "swift"
        let request1 = SearchModel.Search.Request.search(keyword: keyword1)
        let request2 = SearchModel.Search.Request.search(keyword: keyword2)

        // When
        interactor.searchRequest(request1)
        wait(for: 0.05)

        interactor.searchRequest(request2)
        wait(for: 0.2)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 1)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testDuplicatedSearchRequest() throws {
        // Given
        let keyword = "swift"
        let request1 = SearchModel.Search.Request.search(keyword: keyword)
        let request2 = SearchModel.Search.Request.search(keyword: keyword)

        // When
        interactor.searchRequest(request1)
        wait(for: 0.05)

        interactor.searchRequest(request2)
        wait(for: 0.2)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 1)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testCancelSearchNextPageRequestWhenNewSearchRequestIsIncoming() throws {
        // Given
        let keyword1 = "swif"
        let request1 = SearchModel.Search.Request.search(keyword: keyword1)
        let nextPageRequest = SearchModel.Search.Request.nextPage

        let keyword2 = "swift"
        let request2 = SearchModel.Search.Request.search(keyword: keyword2)

        // When
        interactor.searchRequest(request1)
        wait(for: 0.15)

        interactor.searchRequest(nextPageRequest)

        interactor.searchRequest(request2)
        wait(for: 0.2)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 2)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testSearchNextPageRequestWhenFirstSearchNextPageRequestIsInProgress() throws {
        // Given
        let keyword1 = "swif"
        let request1 = SearchModel.Search.Request.search(keyword: keyword1)

        let nextPageRequest = SearchModel.Search.Request.nextPage

        // When
        interactor.searchRequest(request1)
        wait(for: 0.15)

        interactor.searchRequest(nextPageRequest)
        wait(for: 0.05)

        interactor.searchRequest(nextPageRequest)
        wait(for: 0.15)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 2)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }


    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        waitForExpectations(timeout: duration + 0.5)
    }
}
