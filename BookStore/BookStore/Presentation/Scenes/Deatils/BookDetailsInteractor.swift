//
//  BookDetailsInteractor.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation

protocol BookDetailsRouting {
    func routeToSafari(withURL url: URL)
}

protocol BookDetailsPresentable {
    func presentBookDetails(response: BookDetailsModel.Details.Response)
}

final class BookDetailsInteractor: BookDetailsInteractable {

    typealias Response = BookDetailsModel.Details.Response

    var presenter: BookDetailsPresentable?
    var router: BookDetailsRouting?

    private var state: BookDetailsModel.Details.State
    private let bookDetailsRepository: BookDetailsRepository
    private let isbn13Validator: ISBN13validating

    init(
        initialState: BookDetailsModel.Details.State,
        bookDetailsRepository: BookDetailsRepository,
        isbn13Validator: ISBN13validating
    ) {
        state = initialState
        self.bookDetailsRepository = bookDetailsRepository
        self.isbn13Validator = isbn13Validator
    }

    deinit {
        print("deinit: \(type(of: self))")
    }

    func bookDetails(request: BookDetailsModel.Details.Request) {
        switch request {
        case .bookDetails:
            requestBookDetailsWhenISBN13IsValid()

        case let .routeToSafari(url):
            routeRequestToSafari(with: url)
        }
    }

    private func requestBookDetailsWhenISBN13IsValid() {
        if isbn13Validator.isValid(isbn13: state.isbn13) {
            requestBookDetails()
        } else {
            presentErrorResponse(error: .isbnError)
        }
    }

    private func requestBookDetails() {
        bookDetailsRepository.bookDetails(isbn13: state.isbn13) { [weak self] response in
            switch response {
            case let .success(result):
                self?.presentBookDetails(by: result)

            case let .failure(error):
                self?.presentErrorResponse(error: .undefinedError(error.localizedDescription))
            }
        }
    }

    private func presentBookDetails(by bookDetailsResponse: BookDetails) {
        switch bookDetailsResponse {
        case let .success(result):
            presentBookDetails(by: result)

        case let .failure(errorMessage):
            presentErrorResponse(error: .resultError(errorMessage))
        }
    }

    private func presentBookDetails(by result: BookDetails.Details) {
        guard let presenter = presenter else { return }
        let response = Response.result(result)
        presenter.presentBookDetails(response: response)
    }

    private func presentErrorResponse(error: BookDetailsError) {
        guard let presenter = presenter else { return }
        let response = Response.error(error)
        presenter.presentBookDetails(response: response)
    }

    private func routeRequestToSafari(with url: URL?) {
        if let url = url {
            router?.routeToSafari(withURL: url)
        } else {
            let error = URLError(.badURL)
            presentErrorResponse(error: .urlError(error.localizedDescription))
        }
    }
}
