//
//  BookDetailsPresenterSpy.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation
@testable import BookStore

final class BookDetailsPresenterSpy: BookDetailsPresentable {
    
    var presentBookDetailsCallCount: Int = 0
    var resultCaseCallCount: Int = 0
    var errorCaseCallCount: Int = 0
    var isbnErrorCallCount: Int = 0
    var resultErrorCallCount: Int = 0
    var undefinedErrorCallCount: Int = 0
    var urlErrorCallCount: Int = 0
    
    func presentBookDetails(response: BookDetailsModel.Details.Response) {
        presentBookDetailsCallCount += 1
        
        switch response {
        case .result:
            resultCaseCallCount += 1
            
        case let .error(error):
            errorCaseCallCount += 1
            
            switch error {
            case .isbnError:
                isbnErrorCallCount += 1
            case .resultError:
                resultErrorCallCount += 1
            case .undefinedError:
                undefinedErrorCallCount += 1
            case .urlError:
                urlErrorCallCount += 1
            }
        }
    }
}
