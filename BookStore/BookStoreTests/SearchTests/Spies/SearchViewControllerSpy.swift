//
//  SearchViewControllerSpy.swift
//  BookStoreTests
//
//  Created by Elon on 2021/11/18.
//

import Foundation
@testable import BookStore

final class SearchViewControllerSpy: SearchViewControllable {
    
    var sectionsCount: Int = 0
    var displayCallCount: Int = 0
    var displayViewModelCallCount: Int = 0
    var displayErrorAlertCallCount: Int = 0
    
    func display(viewModel: SearchModel.Search.ViewModel) {
        displayCallCount += 1
        
        switch viewModel {
        case let .sections(sections):
            sectionsCount = sections.count
            displayViewModelCallCount += 1
            
        case .errorAlert:
            displayErrorAlertCallCount += 1
        }
    }
}
