//
//  SortView.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation
import UIKit

final class SortView: UIView {
    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.text = "Sort by:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ascendingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = Constants.cornerRadius
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(ascendingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var descendingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = Constants.cornerRadius
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(descendingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public properties

    var isSortByAscendingCompletion: ((Bool) -> Void)?
    var isAscendingButtonSelectedByDefault: Bool = false {
        didSet {
            if isAscendingButtonSelectedByDefault {
                setButtonSelect(ascendingButton)
            }
        }
    }

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
        backgroundColor = .clear

        addSubview(titleLabel)
        addSubview(ascendingButton)
        addSubview(descendingButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            ascendingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            ascendingButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.edgeInset),
            ascendingButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            ascendingButton.widthAnchor.constraint(equalTo: ascendingButton.heightAnchor, multiplier: 1.5),

            descendingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            descendingButton.leadingAnchor.constraint(equalTo: ascendingButton.trailingAnchor, constant: Constants.edgeInset),
            descendingButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            descendingButton.widthAnchor.constraint(equalTo: descendingButton.heightAnchor, multiplier: 1.5)
        ])
    }

    private func setButtonSelect(_ button: UIButton) {
        button.isSelected = true
        button.backgroundColor = .red.withAlphaComponent(0.5)
        button.tintColor = .white
    }

    private func setButtonDeselect(_ button: UIButton) {
        button.isSelected = false
        button.backgroundColor = .systemGray4
        button.tintColor = .black
    }

    @objc private func ascendingButtonTapped() {
        setButtonSelect(ascendingButton)
        setButtonDeselect(descendingButton)

        isSortByAscendingCompletion?(true)
    }

    @objc private func descendingButtonTapped() {
        setButtonSelect(descendingButton)
        setButtonDeselect(ascendingButton)

        isSortByAscendingCompletion?(false)
    }
}

// MARK: - Layout constants

extension SortView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let edgeInset: CGFloat = 16
    }
}
