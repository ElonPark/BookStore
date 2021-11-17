//
//  BookDetailsPresenter.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

protocol BookDetailsViewControllable: AnyObject {
    func display(viewModel: BookDetailsModel.Details.ViewModel)
}

final class BookDetailsPresenter: BookDetailsPresentable {

    typealias ViewModel = BookDetailsModel.Details.ViewModel

    weak var viewController: BookDetailsViewControllable?

    deinit {
        print("deinit: \(type(of: self))")
    }

    func presentBookDetails(response: BookDetailsModel.Details.Response) {
        switch response {
        case let .result(result):
            displayViewModelSections(for: result)

        case let .error(error):
            displayError(error)
        }
    }

    private func displayViewModelSections(for bookDetails: BookDetails.Details) {
        guard let viewController = viewController else { return }

        let sections = makeViewModelSections(bookDetails)
        let viewModel = ViewModel.sections(sections)
        viewController.display(viewModel: viewModel)
    }

    private func makeViewModelSections(_ bookDetails: BookDetails.Details) -> [ViewModel.Section] {
        var sections = [makeBookTitleSection(bookDetails)]
        sections.append(contentsOf: makeDetailSections(bookDetails))

        if let pdf = bookDetails.pdf {
            sections.append(makePDFSection(pdf))
        }

        return sections
    }

    private func makeBookTitleSection(_ bookDetails: BookDetails.Details) -> ViewModel.Section {
        let titleViewModel = BooktTitleHeaderViewModel(
            title: bookDetails.title,
            subtitle: bookDetails.subtitle,
            imageURL: URL(string: bookDetails.image)
        )

        return ViewModel.Section.bookTitle(viewModel: titleViewModel, items: [])
    }

    private func makeDetailSections(_ bookDetails: BookDetails.Details) -> [ViewModel.Section] {
        return [
            .detail(title: "Authors", items: [.description(bookDetails.authors)]),
            .detail(title: "Publisher", items: [.description(bookDetails.publisher)]),
            .detail(title: "Language", items: [.description(bookDetails.language)]),
            .detail(title: "ISBN10", items: [.description(bookDetails.isbn10)]),
            .detail(title: "ISBN13", items: [.description(bookDetails.isbn13)]),
            .detail(title: "Pages", items: [.description(bookDetails.pages)]),
            .detail(title: "Year", items: [.description(bookDetails.year)]),
            .detail(title: "Rating", items: [.description(bookDetails.rating)]),
            .detail(title: "Description", items: [.description(bookDetails.desc)]),
            .detail(title: "Price", items: [.description(bookDetails.price)]),
            .detail(title: "URL", items: [.url(makeURLAttributedString(bookDetails.url), URL(string: bookDetails.url))]),
        ]
    }

    private func makeURLAttributedString(_ urlString: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: urlString)
        let range = NSRange(location: 0, length: attributedString.length)
        let value = NSUnderlineStyle.single.rawValue
        attributedString.addAttribute(.underlineStyle, value: value, range: range)
        return attributedString
    }

    private func makePDFSection(_ samplePDFs: [String: String]) -> ViewModel.Section {
        let items: [ViewModel.Section.Item] = samplePDFs.compactMap {
            guard let url = URL(string: $0.value) else { return nil }
            return .pdf(title: $0.key, url: url)
        }

        return .detail(title: "PDF", items: items)
    }

    private func displayError(_ error: BookDetailsError) {
        guard let viewController = viewController else { return }

        let errorMessage: DisplayErrorMessage
        switch error {
        case .isbnError:
            errorMessage = isbnErrorMessage()

        case let .resultError(message):
            errorMessage = bookDetailsErrorMessage(message)

        case let .undefinedError(message):
            errorMessage = bookDetailsErrorMessage(message)

        case let .urlError(message):
            errorMessage = urlErrorMessage(message)
        }

        viewController.display(viewModel: .errorAlert(errorMessage))
    }
    
    private func isbnErrorMessage() -> DisplayErrorMessage {
        return DisplayErrorMessage(
            title: "Book details error",
            message: "Invalid ISBN",
            confirmActionTitle: "Confirm"
        )
    }

    private func bookDetailsErrorMessage(_ message: String) -> DisplayErrorMessage {
        return DisplayErrorMessage(
            title: "Book details error",
            message: message,
            confirmActionTitle: "Confirm"
        )
    }

    private func urlErrorMessage(_ message: String) -> DisplayErrorMessage {
        return DisplayErrorMessage(
            title: "URL error",
            message: message,
            confirmActionTitle: "Confirm"
        )
    }
}
