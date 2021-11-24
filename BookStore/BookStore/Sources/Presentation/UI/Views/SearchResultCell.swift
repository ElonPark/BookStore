//
//  SearchResultCell.swift
//  BookStore
//
//  Created by Elon on 2021/11/18.
//

import UIKit

import ImageDownloader

final class SearchResultCell: BaseTableViewCell {

    typealias ViewModel = SearchModel.Search.ViewModel

    private struct Metric {
        let labelStackViewSpacing: CGFloat = 5.0

        let contentsContainerStackViewSpacing: CGFloat = 8.0
        let contentsContainerStackViewTopMargin: CGFloat = 8.0
        let contentsContainerStackViewBottomMargin: CGFloat = 8.0
        let contentsContainerStackViewLeadingMargin: CGFloat = 16.0
        let contentsContainerStackViewTrailingMargin: CGFloat = 16.0

        let separatorViewHeight: CGFloat = 1.0
        let separatorViewLeadingMargin: CGFloat = 16.0
        let separatorViewTrailingMargin: CGFloat = 16.0
    }

    private let bookTitleHeaderView = BookTitleHeaderView()

    private let isbnLabel: BaseLabel = {
        $0.textColor = Theme.Color.labelText
        $0.font = Theme.Font.contents
        $0.minimumScaleFactor = 0.5
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return $0
    }(BaseLabel())

    private let priceLabel: BaseLabel = {
        $0.textColor = Theme.Color.yellow
        $0.font = Theme.Font.contents
        $0.textAlignment = .left
        return $0
    }(BaseLabel())

    private let urlLabel: BaseLabel = {
        $0.textColor = Theme.Color.secondaryLabelText
        $0.font = Theme.Font.contents
        return $0
    }(BaseLabel())

    private(set) lazy var labelStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = metric.labelStackViewSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private(set) lazy var contentsContainerStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = metric.contentsContainerStackViewSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private let separatorView: UIView = {
        $0.backgroundColor = Theme.Color.separator
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())

    var viewModel: ViewModel.DisplayBook? {
        didSet { updateUI() }
    }

    private let metric = Metric()
    private var imageRequest: ImageDownloadCancelable?

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
        contentsContainerStackView.addArrangedSubview(bookTitleHeaderView)
        labelStackView.addArrangedSubview(isbnLabel)
        labelStackView.addArrangedSubview(priceLabel)
        contentsContainerStackView.addArrangedSubview(labelStackView)
        contentsContainerStackView.addArrangedSubview(urlLabel)
        contentView.addSubview(contentsContainerStackView)
        contentView.addSubview(separatorView)

        setupConstraints()
    }

    private func setupConstraints() {
        setContentsContainerStackViewConstraints()
        setSeparatorViewConstraints()
    }

    private func setContentsContainerStackViewConstraints() {
        NSLayoutConstraint.activate(
            [
                contentsContainerStackView.topAnchor.constraint(
                    equalTo: self.contentView.topAnchor,
                    constant: metric.contentsContainerStackViewTopMargin
                ),
                contentsContainerStackView.bottomAnchor.constraint(
                    equalTo: self.contentView.bottomAnchor,
                    constant: -metric.contentsContainerStackViewBottomMargin
                ),
                contentsContainerStackView.leadingAnchor.constraint(
                    equalTo: self.contentView.leadingAnchor,
                    constant: metric.contentsContainerStackViewLeadingMargin
                ),
                contentsContainerStackView.trailingAnchor.constraint(
                    equalTo: self.contentView.trailingAnchor,
                    constant: -metric.contentsContainerStackViewTrailingMargin
                ),
            ]
        )
    }

    private func setSeparatorViewConstraints() {
        NSLayoutConstraint.activate(
            [
                separatorView.heightAnchor.constraint(equalToConstant: metric.separatorViewHeight),
                separatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                separatorView.leadingAnchor.constraint(
                    equalTo: self.contentView.leadingAnchor,
                    constant: metric.separatorViewLeadingMargin
                ),
                separatorView.trailingAnchor.constraint(
                    equalTo: self.contentView.trailingAnchor,
                    constant: -metric.separatorViewTrailingMargin
                )
            ]
        )
    }

    private func updateUI() {
        if let viewModel = self.viewModel {
            bookTitleHeaderView.viewModel = viewModel.titleHeader
            isbnLabel.text = viewModel.isbn13Text
            priceLabel.text = viewModel.price
            urlLabel.text = viewModel.url?.absoluteString
        } else {
            initUI()
        }
    }

    private func initUI() {
        bookTitleHeaderView.viewModel = nil
        isbnLabel.text = nil
        priceLabel.text = nil
        urlLabel.text = nil
    }
}
