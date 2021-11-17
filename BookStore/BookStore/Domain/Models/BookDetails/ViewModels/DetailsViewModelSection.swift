//
//  DetailsViewModelSection.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation

extension BookDetailsModel.Details.ViewModel {
    enum Section {
        case bookTitle(viewModel: BooktTitleHeaderViewModel, items: [Item])
        case detail(title: String, items: [Item])
    }
}

extension BookDetailsModel.Details.ViewModel.Section {
    var items: [Item] {
        switch self {
        case let .bookTitle(_, items):
            return items
        case let .detail(_, items):
            return items
        }
    }
}

extension BookDetailsModel.Details.ViewModel.Section {
    enum Item {
        case description(String)
        case url(NSAttributedString, URL?)
        case pdf(title: String, url: URL)
    }
}
