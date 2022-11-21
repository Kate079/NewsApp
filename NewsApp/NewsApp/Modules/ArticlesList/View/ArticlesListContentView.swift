//
//  ArticlesListContentView.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import UIKit

final class ArticlesListContentView: UIView {
    // MARK: - Subviews

    private lazy var sortView: SortView = {
        let view = SortView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSortByAscendingCompletion = { [weak self] value in
            guard let self = self else { return }
            self.isSortByAscendingButtonHandler?(value)
        }
        view.isAscendingButtonSelectedByDefault = true
        return view
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = Constants.cornerRadius
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var articlesListTableView: CustomTableView = {
        let tableView = CustomTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.itemSelectedCompletion = { [weak self] urlString in
            guard let urlString else { return }
            self?.configureItemSelectionHandler?(urlString)
        }
        tableView.accessoryButtonSelectedCompletion = { [weak self] item in
//            self?.configureAccessoryButtonHandler?(item)
        }
        tableView.didPullToRefreshCompletion = { [weak self] in
            self?.refreshTableViewCompletion?()
        }
        tableView.loadMoreDataCompletion = { [weak self] in
            self?.configureLoadMoreDataCompletion?()
        }
        return tableView
    }()

    // MARK: - Public properties

    var configureItemSelectionHandler: ((String) -> Void)?
    var configureAccessoryButtonHandler: ((Int, Bool) -> Void)?
    var refreshTableViewCompletion: (() -> Void)?
    var configureLoadMoreDataCompletion: (() -> Void)?
    var isSortByAscendingButtonHandler: ((Bool) -> Void)?
    var configureFilterButtonCompletion: (() -> Void)?

    // MARK: - Private properties

    private var articlesListViewModel: [ArticlesListModel.Article] = []

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

        addSubview(sortView)
        addSubview(filterButton)
        addSubview(articlesListTableView)

        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset)),
            filterButton.heightAnchor.constraint(equalToConstant: Constants.sortViewHeight),
            filterButton.widthAnchor.constraint(equalTo: filterButton.heightAnchor),

            sortView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sortView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortView.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor),
            sortView.heightAnchor.constraint(equalToConstant: Constants.sortViewHeight),

            articlesListTableView.topAnchor.constraint(equalTo: sortView.bottomAnchor),
            articlesListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articlesListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            articlesListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setFilterButtonSelect(_ button: UIButton) {
        button.isSelected = true
        button.backgroundColor = .red.withAlphaComponent(0.5)
        button.tintColor = .white
    }

    private func setFilterButtonDeselect(_ button: UIButton) {
        button.isSelected = false
        button.backgroundColor = .systemGray4
        button.tintColor = .black
    }

    private func updateArticlesListTableView() {
        articlesListTableView.configureView(with: articlesListViewModel)
    }

    @objc private func filterButtonTapped() {
        configureFilterButtonCompletion?()
    }

    // MARK: - Public methods

    func displayArticlesList(_ viewModel: [ArticlesListModel.Article], isPagination: Bool, isFilterSelected: Bool) {
        if isPagination {
            articlesListViewModel.append(contentsOf: viewModel)
        } else {
            articlesListViewModel = viewModel
        }
        if isFilterSelected {
            setFilterButtonSelect(filterButton)
        } else {
            setFilterButtonDeselect(filterButton)
        }
        updateArticlesListTableView()
    }
}

// MARK: - Layout constants

extension ArticlesListContentView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let edgeInset: CGFloat = 16
        static let largeEdgeInset: CGFloat = 64
        static let sortViewHeight: CGFloat = 40
    }
}
