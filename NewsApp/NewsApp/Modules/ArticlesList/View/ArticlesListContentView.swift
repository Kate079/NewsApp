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

    // MARK: - Private properties

    private var articlesListViewModel: ArticlesListModel.ArticlesListViewModel?

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

        addSubview(articlesListTableView)

        NSLayoutConstraint.activate([
            articlesListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.largeEdgeInset),
            articlesListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articlesListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            articlesListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateArticlesListTableView() {
        guard let articlesListViewModel else { return }
        articlesListTableView.configureView(with: articlesListViewModel.articles)
    }

    // MARK: - Public methods

    func displayArticlesList(_ viewModel: ArticlesListModel.ArticlesListViewModel) {
        self.articlesListViewModel = viewModel

        print(articlesListViewModel)
        print(articlesListViewModel?.articles.count)

        updateArticlesListTableView()
    }
}

// MARK: - Layout constants

extension ArticlesListContentView {
    private enum Constants {
        static let edgeInset: CGFloat = 16
        static let largeEdgeInset: CGFloat = 64
    }
}
