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
        fetchArticlesList()
        configureSearchController()
        configureItemSelectionHandler()
        refreshTableViewCompletion()
        configureLoadMoreDataCompletion()
    }

    // MARK: - Private methods

    private func setupRouter() {
        if let navigationController = navigationController {
            self.router = ArticlesListRouter(navigationController: navigationController, factory: factory)
        }
    }

    private func fetchArticlesList() {
        interactor?.loadArticlesList(searchKeyword: "Ukraine", language: NewsLanguage.en, sortBy: NewsSorting.publishedAt, pageSize: 5, page: currentPage)
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
            self.interactor?.loadArticlesList(searchKeyword: "Ukraine", language: NewsLanguage.en, sortBy: NewsSorting.publishedAt, pageSize: 20, page: 1)
        }
    }

    private func configureLoadMoreDataCompletion() {
        contentView?.configureLoadMoreDataCompletion = { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.interactor?.loadArticlesList(searchKeyword: "Ukraine", language: NewsLanguage.en, sortBy: NewsSorting.publishedAt, pageSize: 5, page: self.currentPage)
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
            self?.interactor?.loadArticlesList(searchKeyword: searchText, language: NewsLanguage.en, sortBy: NewsSorting.relevancy, pageSize: 20, page: 1)
        }
    }
}