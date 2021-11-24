//
//  BookDetailsBuilder.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation
import UIKit

import NeedleFoundation

protocol BookDetailsDependency: Dependency {
    var isbn13Validator: ISBN13validating { get }
}

final class BookDetailsComponent: Component<BookDetailsDependency> {

    private let isbn13: String

    fileprivate var initialState: BookDetailsModel.Details.State {
        return BookDetailsModel.Details.State(isbn13: isbn13)
    }

    fileprivate var bookDetailsRepository: BookDetailsRepository {
        return BookDetailsRepositoryImpl(networkProvider: NetworkProvider())
    }

    fileprivate var isbn13Validator: ISBN13validating {
        return dependency.isbn13Validator
    }

    init(parent: Scope, withISBN13 isbn13: String) {
        self.isbn13 = isbn13
        super.init(parent: parent)
    }
}

protocol BookDetailsBuildable {
    func build(withISBN13 isbn13: String) -> UIViewController
}

final class BookDetailsBuilder:
    ComponentizedBuilder<BookDetailsComponent, UIViewController, String>,
    BookDetailsBuildable
{

    override func build(with component: BookDetailsComponent) -> UIViewController {
        let router = BookDetailsRouter()
        let interactor = BookDetailsInteractor(
            initialState: component.initialState,
            bookDetailsRepository: component.bookDetailsRepository,
            isbn13Validator: component.isbn13Validator
        )
        let presenter = BookDetailsPresenter()
        let viewController = BookDetailsViewController()

        viewController.interacter = interactor
        interactor.presenter = presenter
        interactor.router = router
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }

    func build(withISBN13 isbn13: String) -> UIViewController {
        build(withDynamicComponentDependency: isbn13)
    }
}
