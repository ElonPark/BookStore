//
//  SearchModel.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import Foundation

enum SearchModel {
  enum Search {
    enum Request {
      case search(keyword: String)
      case nextPage
      case bookDetails(isbn13: String)
    }
    enum Response {
      case result([BookSearchResult.Book])
      case error(BookSearchError)
    }
    enum ViewModel {
      case sections([Section])
      case errorAlert(DisplayErrorMessage)
    }
    struct State {
      var isLoading: Bool = false
      var searchKeyword: String?
      var searchResult: BookSearchResult.SearchResult?
      var books = [BookSearchResult.Book]()
    }
  }
}
