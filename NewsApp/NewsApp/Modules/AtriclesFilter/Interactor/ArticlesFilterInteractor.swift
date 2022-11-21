//
//  ArticlesFilterInteractor.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation

protocol ArticlesFilterInteractorProtocol: AnyObject {
    func setupFilerData()
}

final class ArticlesFilterInteractor {
    // MARK: - Public properties

    var presenter: ArticlesFilterPresenterProtocol?
}

// MARK: - ArticlesFilterInteractorProtocol

extension ArticlesFilterInteractor: ArticlesFilterInteractorProtocol {
    func setupFilerData() {
        let category: [String] = NewsCategory.allCases.map { $0.rawValue }
        let country: [String] = NewsCountry.allCases.map { $0.rawValue }
        let sources: [String] = NewsSources.allCases.map { $0.name }

        let filerData = [ArticlesFilterModel(title: "category", filter: category),
                         ArticlesFilterModel(title: "country", filter: country),
                         ArticlesFilterModel(title: "sources", filter: sources)]
        presenter?.presentFilterData(filerData)
    }
}
