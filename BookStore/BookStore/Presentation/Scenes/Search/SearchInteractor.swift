//
//  SearchInteractor.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation

protocol SearchRouting {
    func routeToBookDetails(withISBN13 isbn13: String)
}

protocol SearchPresentable: AnyObject {
    func presentSearchResult(response: SearchModel.Search.Response)
}

final class SearchInteractor: SearchInteractable {

    typealias Response = SearchModel.Search.Response

    var presenter: SearchPresentable?
    var router: SearchRouting?

    private var state: SearchModel.Search.State
    private let bookSearchRepository: BookSearchRepository
    private let isbn13Validator: ISBN13validating

    init(
        initialState: SearchModel.Search.State,
        bookSearchRepository: BookSearchRepository,
        isbn13Validator: ISBN13validating
    ) {
        self.state = initialState
        self.bookSearchRepository = bookSearchRepository
        self.isbn13Validator = isbn13Validator
    }

    func searchRequest(_ request: SearchModel.Search.Request) {
        switch request {
        case let .search(keyword):
            search(keyword: keyword)

        case .nextPage:
            requestNextPageWhenHasNextPage()

        case let .bookDetails(isbn13):
            routeToBookDetailsWhenISBN13IsValid(isbn13)
        }
    }

    private func search(keyword: String) {
        guard let searchKeyword = validatedSearchKeyword(keyword) else { return }
        state.searchKeyword = searchKeyword

        bookSearchRepository.search(byKeyword: searchKeyword) { [weak self] response in
            switch response {
            case let .success(result):
                self?.presentSearchResultWhenSearchByKeyword(result)

            case let .failure(error):
                self?.presentErrorResponse(error: .searchError(message: error.localizedDescription))
            }
        }
    }

    private func validatedSearchKeyword(_ keyword: String) -> String? {
        let searchKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchKeyword.isEmpty,
              let encodeKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              encodeKeyword != state.searchKeyword
        else { return nil }

        return encodeKeyword
    }

    private func presentSearchResultWhenSearchByKeyword(_ result: BookSearchResult) {
        switch result {
        case let .success(searchResult):
            var newState = state
            newState.searchResult = searchResult
            newState.books = searchResult.books
            state = newState
            presentSearchResult()

        case let .failure(errorMessage):
            presentErrorResponse(error: .searchError(message: errorMessage))
        }
    }

    private func presentSearchResult() {
        guard let presenter = presenter else { return }
        let response = Response.result(state.books)
        presenter.presentSearchResult(response: response)
    }

    private func presentErrorResponse(error: BookSearchError) {
        guard let presenter = presenter else { return }
        let response = Response.error(error)
        presenter.presentSearchResult(response: response)
    }

    private func requestNextPageWhenHasNextPage() {
        guard !state.isLoading, hasNextPage(), let parameters = searchNextPageParameters() else { return }

        state.isLoading = true
        bookSearchRepository.search(
            byKeyword: parameters.keyword,
            withPagination: parameters.page
        ) { [weak self] response in
            switch response {
            case let .success(result):
                self?.presentSearchResultWhenSearchNextPage(result)

            case let .failure(error):
                print(error)
            }

            self?.state.isLoading = false
        }
    }

    private func presentSearchResultWhenSearchNextPage(_ result: BookSearchResult) {
        switch result {
        case let .success(searchResult):
            guard searchResult.page != state.searchResult?.page else { return }
            var newState = state
            newState.searchResult = searchResult
            newState.books.append(contentsOf: searchResult.books)
            state = newState

            presentSearchResult()

        case let .failure(errorMessage):
            print(errorMessage)
        }
    }

    private func hasNextPage() -> Bool {
        guard let searchResult = state.searchResult, searchResult.page > 0 else { return false }

        let remainingResultsCount = searchResult.total - searchResult.books.count
        let hasNextPage = remainingResultsCount > 0

        return hasNextPage
    }

    private func searchNextPageParameters() -> (keyword: String, page: Int)? {
        guard let keyword = state.searchKeyword,
              let currentPage = state.searchResult?.page
        else { return nil}

        return (keyword, currentPage + 1)
    }

    private func routeToBookDetailsWhenISBN13IsValid(_ isbn13: String) {
        if isbn13Validator.isValid(isbn13: isbn13) {
            router?.routeToBookDetails(withISBN13: isbn13)
        } else {
            presentErrorResponse(error: .isbnError)
        }
    }
}

