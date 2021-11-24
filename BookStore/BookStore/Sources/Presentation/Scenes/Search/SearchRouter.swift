//
//  BookSearchRouter.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

final class SearchRouter: SearchRouting {

  weak var viewController: UIViewController?

  private let bookDetailsBuilder: BookDetailsBuildable

  init(bookDetailsBuilder: BookDetailsBuildable) {
    self.bookDetailsBuilder = bookDetailsBuilder
  }

  func routeToBookDetails(withISBN13 isbn13: String) {
    let bookDetailsViewController = bookDetailsBuilder.build(withISBN13: isbn13)
    viewController?.navigationController?.pushViewController(bookDetailsViewController, animated: true)
  }
}
