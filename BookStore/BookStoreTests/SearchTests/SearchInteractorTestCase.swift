//
//  SearchInteractorTestCase.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import XCTest
@testable import BookStore

class SearchInteractorTestCase: XCTestCase {

    var interactor: SearchInteractor!
    var presenter: SearchPresenterSpy!
    var router: SearchRouterSpy!

    override func setUpWithError() throws {
        let state = SearchModel.Search.State()
        let networkProvider = NetworkProvider<SearchAPI>(stubClosure: NetworkProvider.immediatelyStub)
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

    func testSearchRequestWhenSuccess() throws {
        // Given
        let keyword = "swift"
        let request = SearchModel.Search.Request.search(keyword: keyword)

        // When
        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchSuccessResponseTestData()
        var expectItemsCount: Int? {
            guard case let .success(result) = expectResult else { return nil }
            return result.books.count
        }

        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 1)
        XCTAssertEqual(presenter.responseResultItemsCount, expectItemsCount)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testSearchRequestWhenDuplicatedRequest() throws {
        // Given
        let keyword = "swift"
        let request = SearchModel.Search.Request.search(keyword: keyword)

        // When
        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchSuccessResponseTestData()
        var expectItemsCount: Int? {
            guard case let .success(result) = expectResult else { return nil }
            return result.books.count
        }

        interactor.searchRequest(request)
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 1)
        XCTAssertEqual(presenter.responseResultItemsCount, expectItemsCount)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testSearchRequestErrorWhenKeywordIsEmpty() throws {
        // Given
        let keyword = ""
        let request = SearchModel.Search.Request.search(keyword: keyword)

        // When
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testSearchRequestErrorWhenKeywordIsWhitespace() throws {
        // Given
        let keyword = "    "
        let request = SearchModel.Search.Request.search(keyword: keyword)

        // When
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testSearchRequestErrorWhenErrorResponse() throws {
        // Given
        let state = SearchModel.Search.State()
        let networkProvider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointErrorResponseClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13ValidatorFake()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter
        interactor.router = router

        let keyword = "swift"
        let request = SearchModel.Search.Request.search(keyword: keyword)

        // When
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 1)
        XCTAssertEqual(presenter.searchErrorCallCount, 1)

        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
    }

    func testSearchRequestErrorWhenNetworkError() throws {
        // Given
        let state = SearchModel.Search.State()
        let networkProvider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointNetworkErrorClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13ValidatorFake()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter


        let keyword = "swift"
        let request = SearchModel.Search.Request.search(keyword: keyword)

        // When
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 1)
        XCTAssertEqual(presenter.searchErrorCallCount, 1)

        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
    }

    func testSearchRequestNextPageWhenSuccess() throws {
        // Given
        let keyword = "swift"
        let searchRequest = SearchModel.Search.Request.search(keyword: keyword)
        let nextPageRequest = SearchModel.Search.Request.nextPage

        // When
        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchSuccessResponseTestData()
        var expectItemsCount: Int? {
            guard case let .success(result) = expectResult else { return nil }
            return result.books.count * 2
        }

        interactor.searchRequest(searchRequest)
        interactor.searchRequest(nextPageRequest)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 2)
        XCTAssertEqual(presenter.responseResultItemsCount, expectItemsCount)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testSearchRequestNextPageWhenErrorResponse() throws {
        // Given
        let testDataFactory = BookSearchTestDataFactory()
        let testData = testDataFactory.makeSearchSuccessResponseTestData()
        var searchResult: BookSearchResult.SearchResult? {
            guard case let .success(result) = testData else { return nil }
            return result
        }
        var books: [BookSearchResult.Book] {
            guard case let .success(result) = testData else { return [] }
            return result.books
        }

        let state = SearchModel.Search.State(
            searchKeyword: "swift",
            searchResult: searchResult,
            books: books
        )

        let networkProvider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointErrorResponseClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)

        let isbn13Validator = ISBN13ValidatorFake()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter

        let nextPageRequest = SearchModel.Search.Request.nextPage

        // When
        interactor.searchRequest(nextPageRequest)

        // Then
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
    }

    func testSearchRequestNextPageWhenNetworkError() throws {
        // Given
        let testDataFactory = BookSearchTestDataFactory()
        let testData = testDataFactory.makeSearchSuccessResponseTestData()
        var searchResult: BookSearchResult.SearchResult? {
            guard case let .success(result) = testData else { return nil }
            return result
        }
        var books: [BookSearchResult.Book] {
            guard case let .success(result) = testData else { return [] }
            return result.books
        }

        let state = SearchModel.Search.State(
            searchKeyword: "swift",
            searchResult: searchResult,
            books: books
        )

        let networkProvider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointNetworkErrorClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)

        let isbn13Validator = ISBN13ValidatorFake()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter

        let nextPageRequest = SearchModel.Search.Request.nextPage

        // When
        interactor.searchRequest(nextPageRequest)

        // Then
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
    }

    func testSearchRequestNextPageWhenStateIsEmpty() throws {
        // Given
        let nextPageRequest = SearchModel.Search.Request.nextPage

        // When
        interactor.searchRequest(nextPageRequest)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }


    func testSearchRequestNextPageWhenDuplicatedRequest() throws {
        // Given
        let keyword = "swift"
        let searchRequest = SearchModel.Search.Request.search(keyword: keyword)
        let nextPageRequest1 = SearchModel.Search.Request.nextPage
        let nextPageRequest2 = SearchModel.Search.Request.nextPage

        // When
        let testDataFactory = BookSearchTestDataFactory()
        let expectResult = testDataFactory.makeSearchSuccessResponseTestData()
        var expectItemsCount: Int? {
            guard case let .success(result) = expectResult else { return nil }
            return result.books.count * 2
        }

        interactor.searchRequest(searchRequest)
        interactor.searchRequest(nextPageRequest1)
        interactor.searchRequest(nextPageRequest2)

        // Then
        XCTAssertEqual(presenter.responseResultCaseCallCount, 2)
        XCTAssertEqual(presenter.responseResultItemsCount, expectItemsCount)

        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testRequestBookDetailsWhenISBN13IsValid() throws {
        // Given
        let state = SearchModel.Search.State()
        let networkProvider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointNetworkErrorClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13Validator()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter
        interactor.router = router

        let isbn = "9781617294136"
        let request = SearchModel.Search.Request.bookDetails(isbn13: isbn)

        // When
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(router.routeToBookDetailsCallCount, 1)

        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
        XCTAssertEqual(presenter.isbnErrorCallCount, 0)
    }

    func testRequestBookDetailsWhenISBN13IsInvalid() throws {
        // Given
        let state = SearchModel.Search.State()
        let networkProvider = NetworkProvider<SearchAPI>(
            endpointClosure: SearchAPI.endpointNetworkErrorClosure,
            stubClosure: NetworkProvider.immediatelyStub
        )
        let repository = BookSearchRepositoryImpl(networkProvider: networkProvider)
        let isbn13Validator = ISBN13Validator()

        interactor = SearchInteractor(
            initialState: state,
            bookSearchRepository: repository,
            isbn13Validator: isbn13Validator
        )
        interactor.presenter = presenter
        interactor.router = router

        let isbn = "0000000000000"
        let request = SearchModel.Search.Request.bookDetails(isbn13: isbn)

        // When
        interactor.searchRequest(request)

        // Then
        XCTAssertEqual(presenter.responseErrorCaseCallCount, 1)
        XCTAssertEqual(presenter.isbnErrorCallCount, 1)

        XCTAssertEqual(router.routeToBookDetailsCallCount, 0)
        XCTAssertEqual(presenter.responseResultCaseCallCount, 0)
        XCTAssertEqual(presenter.responseResultItemsCount, 0)
        XCTAssertEqual(presenter.searchErrorCallCount, 0)
    }
}
