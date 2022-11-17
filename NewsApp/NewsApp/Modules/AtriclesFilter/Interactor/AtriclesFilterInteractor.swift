//
//  AtriclesFilterInteractor.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation

protocol AtriclesFilterInteractorProtocol: AnyObject {
    func setupFilerData()
}

final class AtriclesFilterInteractor {
    // MARK: - Public properties

    var presenter: AtriclesFilterPresenterProtocol?
}

// MARK: - AtriclesFilterInteractorProtocol

extension AtriclesFilterInteractor: AtriclesFilterInteractorProtocol {
    func setupFilerData() {
        let title = ["Category", "Country", "Sources"]
        let category: [String] = NewsCategory.allCases.map { $0.rawValue }
        let country: [String] = NewsCountry.allCases.map { $0.rawValue }
        let sources: [String] = NewsSources.allCases.map { $0.name }

        let filerData = AtriclesFilterModel.AtriclesFilterViewModel(title: title, category: category, country: country, sources: sources)
        presenter?.presentFilterData(filerData)
    }
}
