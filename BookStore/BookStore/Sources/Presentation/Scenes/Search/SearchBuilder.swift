//
//  SearchBuilder.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation
import UIKit

import NeedleFoundation

protocol SearchDependency: Dependency {}

final class SearchComponent: Component<SearchDependency> {

    var isbn13Validator: ISBN13validating {
        return ISBN13Validator()
    }

    fileprivate var initialState: SearchModel.Search.State {
        return SearchModel.Search.State()
    }
    
    fileprivate var bookSearchRepository: BookSearchRepository {
        return BookSearchRepositoryImpl(networkProvider: NetworkProvider())
    }

    fileprivate var bookDetailsBuilder: BookDetailsBuildable {
        return BookDetailsBuilder { isbn13 in
            BookDetailsComponent(parent: self, withISBN13: isbn13)
        }
    }
}

protocol SearchBuildable {
    func build() -> UIViewController
}

final class SearchBuilder: ComponentizedBuilder<SearchComponent, UIViewController, Void>,  SearchBuildable {

    override func build(with component: SearchComponent) -> UIViewController {
        let router = SearchRouter(bookDetailsBuilder: component.bookDetailsBuilder)
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

    func build() -> UIViewController {
        return build(withDynamicComponentDependency: Void())
    }
}
