//
//  SearchViewModelDisplayBook.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import Foundation

extension SearchModel.Search.ViewModel {
  struct DisplayBook {
    let titleHeader: BooktTitleHeaderViewModel
    let isbn13: String
    let isbn13Text: String
    let price: String
    let url: URL?
  }
}
