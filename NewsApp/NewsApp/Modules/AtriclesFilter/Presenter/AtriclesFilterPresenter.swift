//
//  AtriclesFilterPresenter.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation

protocol AtriclesFilterPresenterProtocol: AnyObject {
    func presentFilterData(_ data: AtriclesFilterModel.AtriclesFilterViewModel)
}

final class AtriclesFilterPresenter {
    // MARK: - Public properties

    weak var viewController: AtriclesFilterViewControllerProtocol?
}

// MARK: - AtriclesFilterPresenterProtocol

extension AtriclesFilterPresenter: AtriclesFilterPresenterProtocol {
    func presentFilterData(_ data: AtriclesFilterModel.AtriclesFilterViewModel) {
        viewController?.displayFilterData(viewModel: data)
    }
}
