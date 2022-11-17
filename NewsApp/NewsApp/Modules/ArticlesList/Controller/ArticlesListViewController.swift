//
//  ArticlesListViewController.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import UIKit

protocol ArticlesListViewControllerProtocol: AnyObject {
    func displayArticlesList(viewModel: ArticlesListModel.ArticlesListViewModel)
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
    private var factory: MainFactoryProtocol
    private var timer: Timer?
    private var currentPage = 1

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
        fetchArticlesList(page: 1)
        configureSearchController()
        configureItemSelectionHandler()
        refreshTableViewCompletion()
        configureLoadMoreDataCompletion()
        sortByAscendingButtonHandler()
        configureFilterButtonCompletion()
    }

    // MARK: - Private methods

    private func setupRouter() {
        if let navigationController = navigationController {
            self.router = ArticlesListRouter(navigationController: navigationController, factory: factory)
        }
    }

    private func fetchArticlesList(searchKeyword: String? = "Ukraine", sortBy: NewsSorting? = .publishedAt, isSortByAscending: Bool = true, page: Int?) {
        interactor?.loadArticlesList(searchKeyword: searchKeyword, sortBy: sortBy, isSortByAscending: isSortByAscending, page: page)
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
            self.fetchArticlesList(page: 1)
        }
    }

    private func configureLoadMoreDataCompletion() {
        contentView?.configureLoadMoreDataCompletion = { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.fetchArticlesList(page: self.currentPage)
        }
    }

    private func sortByAscendingButtonHandler() {
        contentView?.isSortByAscendingButtonHandler = { [weak self] value in
            guard let self = self else { return }
            self.fetchArticlesList(isSortByAscending: value, page: self.currentPage)
        }
    }

    private func configureFilterButtonCompletion() {
        contentView?.configureFilterButtonCompletion = { [weak self] in
            guard let self = self else { return }
            self.router?.showFilter()
        }
    }
}

// MARK: - ArticlesListViewControllerProtocol

extension ArticlesListViewController: ArticlesListViewControllerProtocol {
    func displayArticlesList(viewModel: ArticlesListModel.ArticlesListViewModel) {
        contentView?.displayArticlesList(viewModel)
    }

    func showErrorAlert(with errorDescription: String, handler: (() -> Void)?) {
//        let alert = AlertController(title: StringConstants.errorTitle, message: errorDescription)
//        alert.tapButtonOnAlertCompletion = handler
//        alert.setAction(titleForButton: StringConstants.okTitle)
//        self.present(alert, animated: true)

        print(errorDescription)
    }
}

// MARK: - UISearchBarDelegate

extension ArticlesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.fetchArticlesList(searchKeyword: searchText, sortBy: NewsSorting.relevancy, page: 1)
        }
    }
}
