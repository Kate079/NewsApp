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

    private lazy var filterByCategory: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.itemSelectedCompletion = { [weak self] filter in
            guard let self else { return }
            self.updateSelectedFilters(with: filter, for: self.filterByCategory)
            self.configureApplyButton()
        }
        return collectionView
    }()

    private lazy var filterByCountry: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.itemSelectedCompletion = { [weak self] filter in
            guard let self else { return }
            self.updateSelectedFilters(with: filter, for: self.filterByCountry)
            self.configureApplyButton()
        }
        return collectionView
    }()

    private lazy var filterBySources: HorizontalCollectionView = {
        let collectionView = HorizontalCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.itemSelectedCompletion = { [weak self] filter in
            guard let self else { return }
            self.updateSelectedFilters(with: filter, for: self.filterBySources)
            self.configureApplyButton()
        }
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

    var applyButtonCompletion: (([String: String]) -> Void)?

    // MARK: - Private properties

    private var configurationData: [ArticlesFilterModel]?
    private var selectedFilters: [String: String] = [:]

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        configureApplyButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .systemGray6

        addSubview(titleLabel)
        addSubview(filterByCategory)
        addSubview(filterByCountry)
        addSubview(filterBySources)
        addSubview(applyButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.edgeInset),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            filterByCategory.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.edgeInset),
            filterByCategory.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            filterByCategory.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            filterByCategory.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),

            filterByCountry.topAnchor.constraint(equalTo: filterByCategory.bottomAnchor),
            filterByCountry.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            filterByCountry.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            filterByCountry.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),

            filterBySources.topAnchor.constraint(equalTo: filterByCountry.bottomAnchor),
            filterBySources.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            filterBySources.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            filterBySources.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),

            applyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            applyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -(Constants.edgeInset))
        ])
    }

    private func configureApplyButton() {
        if selectedFilters.isEmpty {
            setButtonDisabled()
        } else {
            setButtonEnabled()
        }
    }

    private func setButtonEnabled() {
        applyButton.isEnabled = true
        applyButton.backgroundColor = .red.withAlphaComponent(0.5)
        applyButton.setTitleColor(UIColor.white, for: .normal)
    }

    private func setButtonDisabled() {
        applyButton.isEnabled = false
        applyButton.backgroundColor = .systemGray4
        applyButton.setTitleColor(UIColor.black, for: .normal)
    }

    private func updateSelectedFilters(with filter: [String: String]?, for collectionView: HorizontalCollectionView) {
        guard let filterKey = filter?.keys.first, let filterValue = filter?.values.first else { return }

        if selectedFilters.keys.contains(filterKey) && selectedFilters.values.contains(filterValue) {
            selectedFilters.removeValue(forKey: filterKey)
            collectionView.deselectItem()
        } else {
            if filterKey == "sources" {
                selectedFilters = [:]
                filterByCategory.deselectItem()
                filterByCountry.deselectItem()
                selectedFilters.updateValue(filterValue, forKey: filterKey)
            } else {
                filterBySources.deselectItem()
                selectedFilters.removeValue(forKey: "sources")
                selectedFilters.updateValue(filterValue, forKey: filterKey)
            }
        }
    }

    @objc private func applyButtonTapped() {
        applyButtonCompletion?(selectedFilters)
    }

    // MARK: - Public methods

    func configureView(with data: [ArticlesFilterModel]) {
        configurationData = data
        filterByCategory.configureView(with: data[0])
        filterByCountry.configureView(with: data[1])
        filterBySources.configureView(with: data[2])
    }

    func updateFilterWithSelectedItems(with filter: [String: String]) {
        selectedFilters = filter

        // TODO: update selected items
//        filterByCategory.updateSelectedItem(for: 0)
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
