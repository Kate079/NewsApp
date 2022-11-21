//
//  ArticlesListRouter.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import UIKit

protocol ArticlesListRouterProtocol: AnyObject {
    func showWebView(_ url: URL)
    func showFilter()
    func showFavoriteArticles()
}

final class ArticlesListRouter {
    // MARK: - Public properties

    var navigationController: UINavigationController
    var factory: MainFactoryProtocol

    // MARK: - Lifecycle

    init(navigationController: UINavigationController, factory: MainFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
}

// MARK: - ArticlesListRouterProtocol

extension ArticlesListRouter: ArticlesListRouterProtocol {
    func showWebView(_ url: URL) {
        let webView = factory.makeWebViewScreen(url: url)
        navigationController.pushViewController(webView, animated: true)
    }

    func showFilter() {
        let filterView = factory.makeArticlesFilterScreen()
        navigationController.pushViewController(filterView, animated: true)
    }

    func showFavoriteArticles() {

    }
}
