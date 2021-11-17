//
//  SearchBuilder.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation
import UIKit

final class SearchComponent {

    fileprivate var initialState: SearchModel.Search.State {
        return SearchModel.Search.State()
    }

    fileprivate var bookSearchRepository: BookSearchRepository {
        return BookSearchRepositoryImpl(networkProvider: NetworkProvider())
    }

    fileprivate var isbn13Validator: ISBN13validating {
        return ISBN13Validator()
    }
}

protocol BookSearchBuildable {
    func build() -> UIViewController
}

final class BookSearchBuilder: BookSearchBuildable {

    func build() -> UIViewController {
        let component = SearchComponent()

        let bookDetailsBuilder = BookDetailsBuilder()

        let router = SearchRouter(bookDetailsBuilder: bookDetailsBuilder)
        let interactor = SearchInteractor(
            initialState: component.initialState,
            bookSearchRepository: component.bookSearchRepository,
            isbn13Validator: component.isbn13Validator
        )
        let presenter = SearchPresenter()
        let viewController = SearchViewController()

        viewController.interacter = interactor
        interactor.presenter = presenter
        interactor.router = router
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
