//
//  BookTitleHeaderView.swift
//  BookStore
//
//  Created by Elon on 2021/11/17.
//

import UIKit
import ImageDownloader

final class BookTitleHeaderView: BaseView {

    private struct Metric {
        let labelStackViewSpacing: CGFloat = 8.0
        let labelStackViewLeading: CGFloat = 16.0
        let bookCoverImageViewSize = CGSize(width: 100, height: 150)
    }

    let bookCoverImageView: BaseImageView = {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Theme.Color.imageBackground
        return $0
    }(BaseImageView())

    let titleLabel: BaseLabel = {
        $0.textColor = Theme.Color.labelText
        $0.font = Theme.Font.title
        $0.numberOfLines = 0
        return $0
    }(BaseLabel())

    let subtitleLabel: BaseLabel = {
        $0.textColor = Theme.Color.secondaryLabelText
        $0.font = Theme.Font.subtitle
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return $0
    }(BaseLabel())

    private(set) lazy var labelStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.spacing = metric.labelStackViewSpacing
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private let metric = Metric()

    private(set) var imageRequest: ImageDownloadCancelable?

    var viewModel: BooktTitleHeaderViewModel? {
        didSet { updateUI() }
    }

    override func initialize() {
        super.initialize()
        layout()
    }

    private func updateUI() {
        if let viewModel = self.viewModel {
            imageRequest?.cancel()
            imageRequest = bookCoverImageView.setImage(with: viewModel.imageURL)
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
        } else {
            bookCoverImageView.image = nil
            titleLabel.text = nil
            subtitleLabel.text = nil
        }
    }

    private func layout() {
        addSubview(bookCoverImageView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        addSubview(labelStackView)

        setupConstraints()
    }

    private func setupConstraints() {
        setBookCoverImageViewConstraints()
        setLabelStackViewConstraints()
    }

    private func setBookCoverImageViewConstraints() {
        NSLayoutConstraint.activate(
            [
                bookCoverImageView.widthAnchor.constraint(equalToConstant: metric.bookCoverImageViewSize.width),
                bookCoverImageView.heightAnchor.constraint(equalToConstant: metric.bookCoverImageViewSize.height),
                bookCoverImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                bookCoverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bookCoverImageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
                bookCoverImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
            ]
        )
    }

    private func setLabelStackViewConstraints() {
        NSLayoutConstraint.activate(
            [
                labelStackView.leadingAnchor.constraint(
                    equalTo: bookCoverImageView.trailingAnchor,
                    constant: metric.labelStackViewLeading
                ),
                labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                labelStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
                labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
            ]
        )
    }
}
