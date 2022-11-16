//
//  ArticlesListInteractor.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation

protocol ArticlesListInteractorProtocol: AnyObject {
    func loadArticlesList(searchKeyword: String?, language: NewsLanguage?, sortBy: NewsSorting?, pageSize: Int?, page: Int?)
    func loadArticlesTopHeadlines(country: NewsCountry?, category: NewsCategory?, sources: NewsSources?, searchKeyword: String?, page: Int?)
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
    func loadArticlesList(searchKeyword: String?, language: NewsLanguage?, sortBy: NewsSorting?, pageSize: Int?, page: Int?) {
        newsService.getAllNews(data: NewsTarget.NewsRequestData(searchKeyword: searchKeyword, language: language, sortBy: sortBy, pageSize: pageSize, page: page)) { [weak self] result in
            switch result {
            case .success(let response):
                let responseData = ArticlesListModel.LoadData.ArticlesListResponse(articlesData: response)
                self?.presenter?.presentArticlesList(data: responseData)
            case .failure(let error):
                self?.presenter?.presentErrorAlert(with: error.localizedText, handler: nil)
            }
        }
    }

    func loadArticlesTopHeadlines(country: NewsCountry?, category: NewsCategory?, sources: NewsSources?, searchKeyword: String?, page: Int?) {
        newsService.getTopHeadlines(data: NewsTarget.HeadlinesRequestData(country: country, category: category, sources: sources, searchKeyword: searchKeyword, page: page)) { [weak self] result in
            switch result {
            case .success(let response):
                let responseData = ArticlesListModel.LoadData.ArticlesListResponse(articlesData: response)
                self?.presenter?.presentArticlesList(data: responseData)
            case .failure(let error):
                self?.presenter?.presentErrorAlert(with: error.localizedText, handler: nil)
            }
        }
    }
}
