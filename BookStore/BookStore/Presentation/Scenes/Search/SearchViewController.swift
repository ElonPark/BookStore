//
//  SearchViewController.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

protocol SearchInteractable: AnyObject {
    func searchRequest(_ request: SearchModel.Search.Request)
}

final class SearchViewController: BaseUIViewController, ErrorAlertable {

    typealias Request = SearchModel.Search.Request
    typealias ViewModel = SearchModel.Search.ViewModel

    private let searchController = UISearchController(searchResultsController: nil)

    private let tableView: UITableView = {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(SearchResultCell.self)
        return $0
    }(UITableView(frame: .zero, style: .plain))

    var interacter: SearchInteractable?

    private var sections = [SearchModel.Search.ViewModel.Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        layout()
    }

    private func setupProperties() {
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavigationBar() {
        navigationItem.title = "BookStore"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
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
}

// MARK: - SearchViewControllable

extension SearchViewController: SearchViewControllable {
    func display(viewModel: ViewModel) {
        switch viewModel {
        case let .sections(sections):
            updateSearchResult(sections)

        case let .errorAlert(displayErrorAlert):
            showErrorAlert(with: displayErrorAlert)
        }
    }

    private func updateSearchResult(_ sections: [ViewModel.Section]) {
        self.sections = sections
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        perform(#selector(searchKeywordBySearchBarInput), with: nil, afterDelay: 0.7)
    }

    @objc private func searchKeywordBySearchBarInput() {
        guard let keyword = searchController.searchBar.text else { return }
        searchRequest(withKeyword: keyword)
    }

    private func searchRequest(withKeyword keyword: String) {
        guard let interacter = interacter else { return }
        let request = Request.search(keyword: keyword)
        interacter.searchRequest(request)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.searchBar.endEditing(true)

        let item = sections[indexPath.section].items[indexPath.row]
        guard case let .book(viewModel) = item else { return }
        requestBookDetails(byISBN13: viewModel.isbn13)
    }

    private func requestBookDetails(byISBN13 isbn13: String) {
        guard let interacter = interacter else { return }
        let request = Request.bookDetails(isbn13: isbn13)
        interacter.searchRequest(request)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLastSearchResult(forRowAt: indexPath) else { return }
        requestSearchResultNextPage()
    }

    private func isLastSearchResult(forRowAt indexPath: IndexPath) -> Bool {
        guard !sections.isEmpty else { return false }
        let lastSectionNumber = sections.count - 1
        let isLastSection = indexPath.section == lastSectionNumber

        let lastItemRow = sections[indexPath.section].items.count - 1
        let isLastRow = indexPath.row == lastItemRow

        return isLastSection && isLastRow
    }

    private func requestSearchResultNextPage() {
        guard let interacter = interacter else { return }
        let request = Request.nextPage
        interacter.searchRequest(request)
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeue(for: indexPath)

        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case let .book(viewModel):
            cell.viewModel = viewModel
        }

        return cell
    }
}
