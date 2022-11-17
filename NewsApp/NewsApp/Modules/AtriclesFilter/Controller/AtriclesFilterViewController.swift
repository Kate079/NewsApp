//
//  FilterViewController.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import UIKit

protocol FilterViewControllerProtocol: AnyObject {
    func displayFilterData(viewModel: AtriclesFilterModel.AtriclesFilterViewModel)
}

class FilterViewController: UIViewController {
    // MARK: - Public properties

//    var router: ArticlesListRouterProtocol?
    var interactor: FilterInteractorProtocol?

    // MARK: - Private properties

    private var contentView: FilterView? {
        return view as? FilterView
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = FilterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = "Breaking News"
//        navigationController?.isNavigationBarHidden = false
//        setupRouter()
//        fetchArticlesList(page: 1)
//        configureSearchController()
//        configureItemSelectionHandler()
//        refreshTableViewCompletion()
//        configureLoadMoreDataCompletion()
//        sortByAscendingButtonHandler()
//        configureFilterButtonCompletion()
    }

    // MARK: - Private methods

//    private func setupRouter() {
//        if let navigationController = navigationController {
//            self.router = ArticlesListRouter(navigationController: navigationController, factory: factory)
//        }
//    }
//
//    private func fetchArticlesList(searchKeyword: String? = "Ukraine", sortBy: NewsSorting? = .publishedAt, isSortByAscending: Bool = true, page: Int?) {
//        interactor?.loadArticlesList(searchKeyword: searchKeyword, sortBy: sortBy, isSortByAscending: isSortByAscending, page: page)
//    }
//
//    private func configureAccessoryButtonHandler() {
//        contentView?.configureAccessoryButtonHandler = { [weak self] itemIndex, isSaved in
//            guard let self = self else { return }
//            print(isSaved)
//            print(itemIndex)
//        }
//    }
//
//    private func configureSearchController() {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//        searchController.searchBar.isHidden = false
//        definesPresentationContext = true
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//    }
//
//    private func configureItemSelectionHandler() {
//        contentView?.configureItemSelectionHandler = { [weak self] urlString in
//            guard let self = self, let url = URL(string: urlString) else { return }
//            self.router?.showWebView(url)
//        }
//    }
}

// MARK: - FilterViewControllerProtocol

extension FilterViewController: FilterViewControllerProtocol {
    func displayFilterData(viewModel: AtriclesFilterModel.AtriclesFilterViewModel) {
        contentView?.configureView(with: viewModel)
    }
}
