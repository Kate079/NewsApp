//
//  ArticlesListInteractor.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation

protocol ArticlesListInteractorProtocol: AnyObject {
    func loadArticlesTopHeadlines(country: String?, category: String?, sources: String?, searchKeyword: String?, page: Int, isPagination: Bool, isSortByAscending: Bool, isFilterSelected: Bool)
}

final class ArticlesListInteractor {
    // MARK: - Public properties

    var presenter: ArticlesListPresenterProtocol?

    // MARK: - Private properties

    private let newsService: NewsServiceProtocol

    // MARK: - Lifecycle

    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
}

// MARK: - ArticlesListInteractorProtocol

extension ArticlesListInteractor: ArticlesListInteractorProtocol {
    func loadArticlesTopHeadlines(country: String?, category: String?, sources: String?, searchKeyword: String?, page: Int, isPagination: Bool, isSortByAscending: Bool, isFilterSelected: Bool) {
        if page < 6 {
            let countryFilter = NewsCountry.allCases.filter { $0.rawValue == country }.first
            let categoryFilter = NewsCategory.allCases.filter { $0.rawValue == category }.first
            let sourcesFilter = NewsSources.allCases.filter { $0.name == sources }.first
            
            newsService.getTopHeadlines(data: NewsTarget.HeadlinesRequestData(country: countryFilter, category: categoryFilter, sources: sourcesFilter, searchKeyword: searchKeyword, page: page)) { [weak self] result in
                switch result {
                case .success(let response):
                    let responseData = ArticlesListModel.LoadData.ArticlesListResponse(articlesData: response)
                    self?.presenter?.presentArticlesList(data: responseData, isSortByAscending: isSortByAscending, isPagination: isPagination, isFilterSelected: isFilterSelected)
                case .failure(let error):
                    self?.presenter?.presentErrorAlert(with: error.localizedText, handler: nil)
                }
            }
        }
    }
}
