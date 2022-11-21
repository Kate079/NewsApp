//
//  ArticlesListViewController.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import UIKit
import RealmSwift

protocol ArticlesListViewControllerProtocol: AnyObject {
    func displayArticlesList(viewModel: ArticlesListModel.ArticlesListViewModel, isPagination: Bool, isFilterSelected: Bool)
    func showErrorAlert(with errorDescription: String, handler: (() -> Void)?)
}

class ArticlesListViewController: UIViewController {
    // MARK: - Subviews

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()

    // MARK: - Public properties

    var router: ArticlesListRouterProtocol?
    var interactor: ArticlesListInteractorProtocol?

    // MARK: - Private properties

    private var contentView: ArticlesListContentView? {
        return view as? ArticlesListContentView
    }
    private let realm = try! Realm()
    private lazy var filters = realm.objects(SelectedFilter.self)
    private var factory: MainFactoryProtocol
    private var timer: Timer?
    private var currentPage = 1
    private var searchKeyword: String?
    private var isSortByAscending = true

    // MARK: - Lifecycle

    init(factory: MainFactoryProtocol) {
        self.factory = factory

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ArticlesListContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Breaking News"
        navigationController?.isNavigationBarHidden = false
        setupRouter()
        configureSearchController()
        configureItemSelectionHandler()
        refreshTableViewCompletion()
        configureLoadMoreDataCompletion()
        sortByAscendingButtonHandler()
        configureFilterButtonCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if filters.isEmpty {
            fetchTopHeadlines()
        } else {
            let country = getFilterValueForKey(StringConstants.country)
            let category = getFilterValueForKey(StringConstants.category)
            let sources = getFilterValueForKey(StringConstants.sources)

            fetchTopHeadlines(country: country, category: category, sources: sources, searchKeyword: nil, isSortByAscending: isSortByAscending, isFilterSelected: true)
        }
    }

    // MARK: - Private methods

    private func setupRouter() {
        if let navigationController = navigationController {
            self.router = ArticlesListRouter(navigationController: navigationController, factory: factory)
        }
    }

    private func fetchTopHeadlines(
        country: String? = nil,
        category: String? = nil,
        sources: String? = nil,
        searchKeyword: String? = "Ukraine",
        page: Int = 1,
        isPagination: Bool = false,
        isSortByAscending: Bool = true,
        isFilterSelected: Bool = false) {
        interactor?.loadArticlesTopHeadlines(country: country, category: category, sources: sources, searchKeyword: searchKeyword, page: page, isPagination: isPagination, isSortByAscending: isSortByAscending, isFilterSelected: isFilterSelected)
    }

    private func configureAccessoryButtonHandler() {
        contentView?.configureAccessoryButtonHandler = { [weak self] itemIndex, isSaved in
            guard let self = self else { return }
            print(isSaved)
            print(itemIndex)
        }
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.isHidden = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func configureItemSelectionHandler() {
        contentView?.configureItemSelectionHandler = { [weak self] urlString in
            guard let self = self, let url = URL(string: urlString) else { return }
            self.router?.showWebView(url)
        }
    }

    private func refreshTableViewCompletion() {
        contentView?.refreshTableViewCompletion = { [weak self] in
            guard let self = self else { return }
            if self.filters.isEmpty {
                guard let searchKeyword = self.searchKeyword else {
                    self.fetchTopHeadlines(isSortByAscending: self.isSortByAscending)
                    return
                }
                self.fetchTopHeadlines(searchKeyword: searchKeyword, isSortByAscending: self.isSortByAscending)
            } else {
                let country = self.getFilterValueForKey(StringConstants.country)
                let category = self.getFilterValueForKey(StringConstants.category)
                let sources = self.getFilterValueForKey(StringConstants.sources)

                self.fetchTopHeadlines(country: country, category: category, sources: sources, searchKeyword: nil, isSortByAscending: self.isSortByAscending, isFilterSelected: true)
            }
        }
    }

    private func configureLoadMoreDataCompletion() {
        contentView?.configureLoadMoreDataCompletion = { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            if self.filters.isEmpty {
                guard let searchKeyword = self.searchKeyword else {
                    self.fetchTopHeadlines(page: self.currentPage, isPagination: true, isSortByAscending: self.isSortByAscending)
                    return
                }
                self.fetchTopHeadlines(searchKeyword: searchKeyword, page: self.currentPage, isPagination: true, isSortByAscending: self.isSortByAscending)
            } else {
                let country = self.getFilterValueForKey(StringConstants.country)
                let category = self.getFilterValueForKey(StringConstants.category)
                let sources = self.getFilterValueForKey(StringConstants.sources)

                guard let searchKeyword = self.searchKeyword else {
                    self.fetchTopHeadlines(country: country, category: category, sources: sources, searchKeyword: nil, page: self.currentPage, isPagination: true, isSortByAscending: self.isSortByAscending, isFilterSelected: true)
                    return
                }
                self.fetchTopHeadlines(country: country, category: category, sources: sources, searchKeyword: searchKeyword, page: self.currentPage, isPagination: true, isSortByAscending: self.isSortByAscending, isFilterSelected: true)
            }
        }
    }

    private func sortByAscendingButtonHandler() {
        contentView?.isSortByAscendingButtonHandler = { [weak self] value in
            guard let self = self else { return }
            self.isSortByAscending = value
            if self.filters.isEmpty {
                self.fetchTopHeadlines(isSortByAscending: value)
            } else {
                let country = self.getFilterValueForKey(StringConstants.country)
                let category = self.getFilterValueForKey(StringConstants.category)
                let sources = self.getFilterValueForKey(StringConstants.sources)

                self.fetchTopHeadlines(country: country, category: category, sources: sources, searchKeyword: nil, page: self.currentPage, isSortByAscending: value, isFilterSelected: true)
            }
        }
    }

    private func configureFilterButtonCompletion() {
        contentView?.configureFilterButtonCompletion = { [weak self] in
            guard let self = self else { return }
            self.router?.showFilter()
        }
    }

    private func getFilterValueForKey(_ key: String) -> String? {
        filters.last?.filters.value(forKey: key) as? String
    }
}

// MARK: - ArticlesListViewControllerProtocol

extension ArticlesListViewController: ArticlesListViewControllerProtocol {
    func displayArticlesList(viewModel: ArticlesListModel.ArticlesListViewModel, isPagination: Bool, isFilterSelected: Bool) {
        contentView?.displayArticlesList(viewModel.articles, isPagination: isPagination, isFilterSelected: isFilterSelected)
    }

    func showErrorAlert(with errorDescription: String, handler: (() -> Void)?) {
        let alert = AlertController(title: StringConstants.errorTitle, message: errorDescription)
        alert.tapButtonOnAlertCompletion = handler
        alert.setAction(titleForButton: StringConstants.okTitle)
        self.present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ArticlesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.searchKeyword = searchText
            self.fetchTopHeadlines(searchKeyword: searchText, isSortByAscending: self.isSortByAscending)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchKeyword = nil
    }
}
