//
//  BookDetailsModel.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation

enum BookDetailsModel {
  enum Details {
    enum Request {
      case bookDetails
      case routeToSafari(url: URL?)
    }
    enum Response {
      case result(BookDetails.Details)
      case error(BookDetailsError)
    }
    enum ViewModel {
      case sections([Section])
      case errorAlert(DisplayErrorMessage)
    }
    struct State {
      let isbn13: String
      var bookDetails: BookDetails.Details?
    }
  }
}
