//
//  TextContentsView.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit

final class TextContentsView: BaseView {
    private struct Metric {
        let contentsLabelTopMargin: CGFloat = 8.0
        let contentsLabelBottomMargin: CGFloat = 8.0
        let contentsLabelLeadingMargin: CGFloat = 16.0
        let contentsLabelTrailingMargin: CGFloat = 16.0
    }

    let contentsLabel: BaseLabel = {
        $0.textColor = Theme.Color.labelText
        $0.font = Theme.Font.title
        $0.numberOfLines = 0
        return $0
    }(BaseLabel())

    private let metric = Metric()

    override func initialize() {
        super.initialize()
        layout()
    }

    private func layout() {
        addSubview(contentsLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                contentsLabel.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: metric.contentsLabelTopMargin
                ),
                contentsLabel.bottomAnchor.constraint(
                    equalTo: self.bottomAnchor,
                    constant: -metric.contentsLabelBottomMargin
                ),
                contentsLabel.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: metric.contentsLabelLeadingMargin
                ),
                contentsLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: self.trailingAnchor,
                    constant: -metric.contentsLabelTrailingMargin
                ),
            ]
        )
    }
}
