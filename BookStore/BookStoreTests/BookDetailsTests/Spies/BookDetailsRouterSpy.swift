//
//  BookDetailsRouterSpy.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation
@testable import BookStore

final class BookDetailsRouterSpy: BookDetailsRouting {
    
    var routeToSafariCallCount: Int = 0
    
    func routeToSafari(withURL url: URL) {
        routeToSafariCallCount += 1
    }
}
