//
//  ArticlesFilterRouter.swift
//  NewsApp
//
//  Created by Kate on 21.11.2022.
//

import Foundation
import UIKit

protocol ArticlesFilterRouterProtocol: AnyObject {
    func returnToPreviousScreen()
}

final class ArticlesFilterRouter {
    // MARK: - Public properties

    var navigationController: UINavigationController

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - ArticlesFilterRouterProtocol

extension ArticlesFilterRouter: ArticlesFilterRouterProtocol {
    func returnToPreviousScreen() {
        navigationController.popViewController(animated: true)
    }
}
