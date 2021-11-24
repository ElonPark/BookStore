//
//  ErrorAlertable.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

protocol ErrorAlertable: UIViewController {
    func showErrorAlert(with displayErrorAlert: DisplayErrorMessage)
    func makeErrorAlert(with displayErrorAlert: DisplayErrorMessage) -> UIAlertController
}

extension ErrorAlertable {
    func showErrorAlert(with displayErrorAlert: DisplayErrorMessage) {
        let alert = makeErrorAlert(with: displayErrorAlert)
        present(alert, animated: true)
    }
    
    func makeErrorAlert(with displayErrorAlert: DisplayErrorMessage) -> UIAlertController {
        let alert = UIAlertController(
            title: displayErrorAlert.title,
            message: displayErrorAlert.message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: displayErrorAlert.confirmActionTitle, style: .cancel)
        alert.addAction(confirmAction)
        
        return alert
    }
}
