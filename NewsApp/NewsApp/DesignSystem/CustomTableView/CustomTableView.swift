//
//  CustomTableView.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import UIKit

final class CustomTableView: UIView {
    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)
        tableView.register(CustomTableViewLoadingCell.self, forCellReuseIdentifier: CustomTableViewLoadingCell.reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return tableView
    }()

    // MARK: - Public properties

    var itemSelectedCompletion: ((String?) -> Void)?
    var accessoryButtonSelectedCompletion: (((Int, Bool)?) -> Void)?
    var didPullToRefreshCompletion: (() -> Void)?
    var loadMoreDataCompletion: (() -> Void)?

    // MARK: - Private properties

    private var configurationData: [ArticlesListModel.Article]?
    private(set) var selectedItem: String? {
        didSet {
            itemSelectedCompletion?(selectedItem)
        }
    }
    private(set) var savedItem: (Int, Bool)? {
        didSet {
            // TODO: get index of saved item and if acBtw in cell is tapped
            accessoryButtonSelectedCompletion?(savedItem)
        }
    }
    private var isLoading = false

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .clear

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.edgeInset),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(Constants.edgeInset)),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.edgeInset),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.edgeInset))
        ])
    }

    @objc private func didPullToRefresh() {
        didPullToRefreshCompletion?()
    }

    // MARK: - Public methods

    func configureView(with data: [ArticlesListModel.Article]) {
        configurationData = data
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        isLoading = false
    }
}

// MARK: - UIScrollViewDelegate

extension CustomTableView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY + scrollView.frame.size.height > contentHeight && !isLoading) {
            isLoading = true
            loadMoreData()
        }
    }

    private func loadMoreData() {
        loadMoreDataCompletion?()
    }
}

// MARK: - UICollectionViewDataSource

extension CustomTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let configurationData else { return 0 }
        switch section {
        case 0:
            return configurationData.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CustomTableViewCell.reuseIdentifier,
                for: indexPath) as? CustomTableViewCell
            else { return UITableViewCell() }

            if let configurationData = configurationData {
                cell.configure(configurationData[indexPath.item])
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CustomTableViewLoadingCell.reuseIdentifier,
                for: indexPath) as? CustomTableViewLoadingCell
            else { return UITableViewCell() }
            if isLoading {
                cell.startAnimation()
            } else {
                cell.stopAnimation()
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CustomTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let configurationData else { return }
        selectedItem = configurationData[indexPath.item].url
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? Constants.cellHeight : Constants.loadingCellHeight
    }
}

// MARK: - Layout constants

extension CustomTableView {
    private struct Constants {
        static let cornerRadius: CGFloat = 16
        static let edgeInset: CGFloat = 8
        static let cellHeight: CGFloat = 240
        static let loadingCellHeight: CGFloat = 64
    }
}
