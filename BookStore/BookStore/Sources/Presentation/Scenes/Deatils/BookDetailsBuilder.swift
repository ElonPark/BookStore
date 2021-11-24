//
//  BookDetailsBuilder.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation
import UIKit

final class BookDetailsComponent {

  private let isbn13: String

  fileprivate var initialState: BookDetailsModel.Details.State {
    return BookDetailsModel.Details.State(isbn13: isbn13)
  }

  fileprivate var bookDetailsRepository: BookDetailsRepository {
    return BookDetailsRepositoryImpl(networkProvider: NetworkProvider())
  }

  fileprivate var isbn13Validator: ISBN13validating {
    return ISBN13Validator()
  }

  init(isbn13: String) {
    self.isbn13 = isbn13
  }
}

protocol BookDetailsBuildable {
  func build(withISBN13 isbn13: String) -> UIViewController
}

final class BookDetailsBuilder: BookDetailsBuildable {

  deinit {
    print("deinit: \(type(of: self))")
  }

  func build(withISBN13 isbn13: String) -> UIViewController {
    let component = BookDetailsComponent(isbn13: isbn13)
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
}
