//
//  ArticlesFilterPresenter.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation

protocol ArticlesFilterPresenterProtocol: AnyObject {
    func presentFilterData(_ data: [ArticlesFilterModel])
}

final class ArticlesFilterPresenter {
    // MARK: - Public properties

    weak var viewController: ArticlesFilterViewControllerProtocol?
}

// MARK: - ArticlesFilterPresenterProtocol

extension ArticlesFilterPresenter: ArticlesFilterPresenterProtocol {
    func presentFilterData(_ data: [ArticlesFilterModel]) {
        viewController?.displayFilterData(viewModel: data)
    }
}
