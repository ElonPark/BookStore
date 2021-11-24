//
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

protocol BookDetailsInteractable {
    func bookDetails(request: BookDetailsModel.Details.Request)
}

final class BookDetailsViewController: BaseUIViewController, ErrorAlertable {

    typealias Request = BookDetailsModel.Details.Request
    typealias ViewModel = BookDetailsModel.Details.ViewModel

    private let tableView: UITableView = {
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.estimatedSectionHeaderHeight = UITableView.automaticDimension
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(BookDetailsHeaderView.self)
        $0.register(BookDetailsSectionTitleHeaderView.self)
        $0.register(BookDetailsCell.self)
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    var interacter: BookDetailsInteractable?

    private var sections = [ViewModel.Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        layout()

        requestBookDetails()
    }

    private func setupProperties() {
        navigationItem.title = "BookDetails"
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func layout() {
        view.addSubview(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )
    }

    private func requestBookDetails() {
        guard let interacter = interacter else { return }
        interacter.bookDetails(request: .bookDetails)
    }
}

// MARK: - BookDetailsViewControllable

extension BookDetailsViewController: BookDetailsViewControllable {
    func display(viewModel: ViewModel) {
        switch viewModel {
        case let .sections(sections):
            updateBookDetails(sections)

        case let .errorAlert(displayErrorMessage):
            showErrorAlert(with: displayErrorMessage)
        }
    }

    private func updateBookDetails(_ sections: [ViewModel.Section]) {
        self.sections = sections
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension BookDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .description:
            break

        case let .url(_, url):
            requestRouteToSafari(with: url)

        case let .pdf(_, url):
            requestRouteToSafari(with: url)
        }
    }

    private func requestRouteToSafari(with url: URL?) {
        guard let interacter = interacter else { return }
        let request = Request.routeToSafari(url: url)
        interacter.bookDetails(request: request)
    }
}

// MARK: - UITableViewDataSource

extension BookDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookDetailsCell = tableView.dequeue(for: indexPath)

        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case let .description(description):
            cell.text = description

        case let .url(attributedText, _):
            cell.attributedText = attributedText

        case let .pdf(title, _):
            cell.text = title
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = sections[section]
        switch item {
        case let .bookTitle(viewModel, _):
            let headerView: BookDetailsHeaderView = tableView.dequeue()
            headerView.viewModel = viewModel
            return headerView

        case let .detail(title, _):
            let headerView: BookDetailsSectionTitleHeaderView = tableView.dequeue()
            headerView.title = title
            return headerView
        }
    }
}
