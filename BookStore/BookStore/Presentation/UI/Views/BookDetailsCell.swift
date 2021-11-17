//
//  BookDetailsCell.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

final class BookDetailsCell: BaseTableViewCell {

    private struct Metric {
        let separatorViewHeight: CGFloat = 1.0
        let separatorViewLeadingMargin: CGFloat = 16.0
        let separatorViewTrailingMargin: CGFloat = 16.0
    }

    private let textContentsView: TextContentsView = {
        $0.contentsLabel.textColor = Theme.Color.labelText
        $0.contentsLabel.font = Theme.Font.contents
        return $0
    }(TextContentsView())

    private let separatorView: BaseView = {
        $0.backgroundColor = Theme.Color.separator
        return $0
    }(BaseView())

    var text: String? {
        didSet {
            textContentsView.contentsLabel.text = text
        }
    }

    var attributedText: NSAttributedString? {
        didSet {
            textContentsView.contentsLabel.attributedText = attributedText
        }
    }

    private let metric = Metric()

    override func initialize() {
        super.initialize()
        selectionStyle = .none
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
        setTextContentsViewConstraints()
    }

    private func setTextContentsViewConstraints() {
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
        textContentsView.contentsLabel.attributedText = nil
        textContentsView.contentsLabel.text = nil
    }
}
