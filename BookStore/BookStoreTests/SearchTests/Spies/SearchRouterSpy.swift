//
//  SearchRouterSpy.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation
@testable import BookStore

final class SearchRouterSpy: SearchRouting {
    
    var routeToBookDetailsCallCount: Int = 0
    
    func routeToBookDetails(withISBN13 isbn13: String) {
        routeToBookDetailsCallCount += 1
    }
}
