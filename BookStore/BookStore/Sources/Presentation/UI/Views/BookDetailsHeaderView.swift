//
//  BookDetailsSectionHeaderView.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

final class BookDetailsHeaderView: BaseTableViewHeaderFooterView {

    private struct Metric {
        let bookTitleHeaderViewSpacing: CGFloat = 8.0
        let bookTitleHeaderViewTopMargin: CGFloat = 8.0
        let bookTitleHeaderViewBottomMargin: CGFloat = 8.0
        let bookTitleHeaderViewLeadingMargin: CGFloat = 16.0
        let bookTitleHeaderViewTrailingMargin: CGFloat = 16.0
    }

    private let bookTitleHeaderView = BookTitleHeaderView()

    var viewModel: BooktTitleHeaderViewModel? {
        didSet { bookTitleHeaderView.viewModel  = viewModel }
    }

    private let metric = Metric()

    override func initialize() {
        super.initialize()
        layout()
        initUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initUI()
    }

    private func layout() {
        contentView.addSubview(bookTitleHeaderView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                bookTitleHeaderView.topAnchor.constraint(
                    equalTo: self.contentView.topAnchor,
                    constant: metric.bookTitleHeaderViewTopMargin
                ),
                bookTitleHeaderView.bottomAnchor.constraint(
                    equalTo: self.contentView.bottomAnchor,
                    constant: -metric.bookTitleHeaderViewBottomMargin
                ),
                bookTitleHeaderView.leadingAnchor.constraint(
                    equalTo: self.contentView.leadingAnchor,
                    constant: metric.bookTitleHeaderViewLeadingMargin
                ),
                bookTitleHeaderView.trailingAnchor.constraint(
                    equalTo: self.contentView.trailingAnchor,
                    constant: -metric.bookTitleHeaderViewTrailingMargin
                ),
            ]
        )
    }

    private func initUI() {
        bookTitleHeaderView.viewModel = nil
    }
}
