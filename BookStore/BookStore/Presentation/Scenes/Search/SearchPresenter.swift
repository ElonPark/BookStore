//
//  SearchPresenter.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import Foundation

protocol SearchViewControllable: AnyObject {
    func display(viewModel: SearchModel.Search.ViewModel)
}

final class SearchPresenter: SearchPresentable {

    typealias ViewModel = SearchModel.Search.ViewModel

    weak var viewController: SearchViewControllable?

    func presentSearchResult(response: SearchModel.Search.Response) {
        switch response {
        case let .result(result):
            displayViewModelSections(for: result)

        case let .error(error):
            displayError(error)
        }
    }

    private func displayViewModelSections(for books: [BookSearchResult.Book]) {
        guard let viewController = viewController else { return }

        let sections = makeViewModelSections(books)
        let viewModel = ViewModel.sections(sections)
        viewController.display(viewModel: viewModel)
    }

    private func makeViewModelSections(_ books: [BookSearchResult.Book]) -> [ViewModel.Section] {
        let sectionItems: [ViewModel.Section.Item] = books.map {
            let titleHeader = BooktTitleHeaderViewModel(
                title: $0.title,
                subtitle: $0.subtitle,
                imageURL: URL(string: $0.image)
            )
            let book = ViewModel.DisplayBook(
                titleHeader: titleHeader,
                isbn13: $0.isbn13,
                isbn13Text: "ISBN13: \($0.isbn13)",
                price: $0.price,
                url: URL(string: $0.url)
            )

            return .book(book)
        }

        return [.searchResult(sectionItems)]
    }

    private func displayError(_ error: BookSearchError) {
        guard let viewController = viewController else { return }

        let errorMessage: DisplayErrorMessage
        switch error {
        case let .searchError(message):
            errorMessage = searchErrorMessage(message)

        case .isbnError:
            errorMessage = isbnErrorMessage()
        }

        viewController.display(viewModel: .errorAlert(errorMessage))
    }

    private func searchErrorMessage(_ message: String) -> DisplayErrorMessage {
        return DisplayErrorMessage(
            title: "Search error",
            message: message,
            confirmActionTitle: "Confirm"
        )
    }

    private func isbnErrorMessage() -> DisplayErrorMessage {
        return DisplayErrorMessage(
            title: "Book details error",
            message: "Invalid ISBN",
            confirmActionTitle: "Confirm"
        )
    }
}
