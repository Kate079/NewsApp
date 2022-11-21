//
//  ArticlesListPresenter.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation

protocol ArticlesListPresenterProtocol: AnyObject {
    func presentArticlesList(data: ArticlesListModel.LoadData.ArticlesListResponse, isSortByAscending: Bool?, isPagination: Bool, isFilterSelected: Bool)
    func presentErrorAlert(with errorDescription: String, handler: (() -> Void)?)
}

final class ArticlesListPresenter {
    // MARK: - Public properties

    weak var viewController: ArticlesListViewControllerProtocol?
}

// MARK: - ArticlesListPresenterProtocol

extension ArticlesListPresenter: ArticlesListPresenterProtocol {
    func presentArticlesList(data: ArticlesListModel.LoadData.ArticlesListResponse, isSortByAscending: Bool?, isPagination: Bool, isFilterSelected: Bool) {
        var articles: [ArticlesListModel.Article] = []

        data.articlesData.articles.forEach { item in
            let source = ArticlesListModel.Source(id: item.source.id ?? "Unknown", name: item.source.name)

            articles.append(ArticlesListModel.Article(
                source: source,
                author: item.author ?? "Unknown",
                title: item.title,
                articleDescription: item.articleDescription ?? "",
                url: item.url,
                urlToImage: item.urlToImage ?? "",
                publishedAt: item.publishedAt,
                isItemSaved: false))
        }

        if let isSortByAscending {
            if isSortByAscending {
                articles.sort { $0.publishedAt.compare($1.publishedAt) == .orderedDescending }
            } else {
                articles.sort { $0.publishedAt.compare($1.publishedAt) == .orderedAscending }
            }
        }

        let viewModel = ArticlesListModel.ArticlesListViewModel(
            totalResults: data.articlesData.totalResults,
            articles: articles)

        viewController?.displayArticlesList(viewModel: viewModel, isPagination: isPagination, isFilterSelected: isFilterSelected)
    }

    func presentErrorAlert(with errorDescription: String, handler: (() -> Void)?) {
        viewController?.showErrorAlert(with: errorDescription, handler: handler)
    }
}
