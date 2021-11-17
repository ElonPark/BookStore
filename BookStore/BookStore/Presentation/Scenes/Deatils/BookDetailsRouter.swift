//
//  BookDetailsRouter.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit
import SafariServices

final class BookDetailsRouter: BookDetailsRouting {

    weak var viewController: UIViewController?

    deinit {
        print("deinit: \(type(of: self))")
    }

    func routeToSafari(withURL url: URL) {
        guard let viewController = viewController else { return }

        let safariViewController = SFSafariViewController(url: url)
        viewController.present(safariViewController, animated: true)
    }
}
