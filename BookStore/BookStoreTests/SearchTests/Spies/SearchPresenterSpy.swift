//
//  SearchPresenterSpy.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation
@testable import BookStore

final class SearchPresenterSpy: SearchPresentable {
    
    var responseResultCaseCallCount: Int = 0
    var responseResultItemsCount: Int = 0
    var responseErrorCaseCallCount: Int = 0
    var searchErrorCallCount: Int = 0
    var isbnErrorCallCount: Int = 0
    
    func presentSearchResult(response: SearchModel.Search.Response) {
        switch response {
        case let .result(items):
            responseResultItemsCount = items.count
            responseResultCaseCallCount += 1
            
        case let .error(error):
            responseErrorCaseCallCount += 1
            
            switch error {
            case .searchError:
                searchErrorCallCount += 1
            case .isbnError:
                isbnErrorCallCount += 1
            }
        }
    }
}
