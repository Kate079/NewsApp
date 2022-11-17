//
//  HorizontalCollectionViewCell.swift
//  Weather
//
//  Created by Kate on 17.11.2022.
//

import Foundation
import UIKit

final class HorizontalCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .systemGray4
        layer.cornerRadius = Constants.cornerRadius

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    func configure(_ item: String) {
        titleLabel.text = item
    }
}

// MARK: - Layout constants

extension HorizontalCollectionViewCell {
    private struct Constants {
        static let cornerRadius: CGFloat = 16
        static let defaultEdgeInset: CGFloat = 16
        static let smallEdgeInset: CGFloat = 8
    }
}
