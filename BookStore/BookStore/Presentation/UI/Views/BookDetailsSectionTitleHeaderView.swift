//
//  BookDetailsSectionTitleHeaderView.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

final class BookDetailsSectionTitleHeaderView: BaseTableViewHeaderFooterView {

    private let textContentsView = TextContentsView()

    var title: String? {
        didSet { textContentsView.contentsLabel.text = title }
    }

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
        contentView.addSubview(textContentsView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                textContentsView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                textContentsView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                textContentsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                textContentsView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ]
        )
    }

    private func initUI() {
        textContentsView.contentsLabel.text = nil
    }
}
