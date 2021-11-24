//
//  SearchViewModelSection.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import Foundation

extension SearchModel.Search.ViewModel {
  enum Section {
    case searchResult([Item])
  }
}

extension SearchModel.Search.ViewModel.Section {
  var items: [Item] {
    switch self {
    case let .searchResult(items):
      return items
    }
  }
}

extension SearchModel.Search.ViewModel.Section {
  enum Item {
    case book(SearchModel.Search.ViewModel.DisplayBook)
  }
}

