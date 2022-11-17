//
//  FilterView.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation
import UIKit

final class FilterView: UIView {
    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.text = "Filter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: VerticalCollectionView = {
        let collectionView = VerticalCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public properties

    var applyButtonCompletion: (() -> Void)?

    // MARK: - Private properties

    private var configurationData: AtriclesFilterModel.AtriclesFilterViewModel?

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
        backgroundColor = .systemGray6

        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(applyButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInset),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.edgeInset),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -(Constants.edgeInset)),

            applyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            applyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -(Constants.edgeInset))
        ])
    }

    // TODO: Button selection, filter applying

//    private func setButtonSelect(_ button: UIButton) {
//        button.isSelected = true
//        button.backgroundColor = .red.withAlphaComponent(0.3)
//        button.tintColor = .red
//    }
//
//    private func setButtonDeselect(_ button: UIButton) {
//        button.isSelected = false
//        button.backgroundColor = .systemGray4
//        button.tintColor = .black
//    }

    private func setButtonSelect() {
        applyButton.isSelected = true
        applyButton.backgroundColor = .red.withAlphaComponent(0.5)
        applyButton.setTitleColor(UIColor.white, for: .normal)
    }

    @objc private func applyButtonTapped() {
        setButtonSelect()

        applyButtonCompletion?()
    }

//    @objc private func descendingButtonAction() {
//        setButtonSelect(descendingButton)
//        setButtonDeselect(ascendingButton)
//
//        isSortByAscendingCompletion?(false)
//    }

    // MARK: - Public methods

    func configureView(with data: AtriclesFilterModel.AtriclesFilterViewModel) {
        configurationData = data
        collectionView.configureView(with: data)
    }
}

// MARK: - Layout constants

extension FilterView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let edgeInset: CGFloat = 16
        static let buttonHeight: CGFloat = 64
    }
}
