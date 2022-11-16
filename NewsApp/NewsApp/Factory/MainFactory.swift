//
//  MainFactory.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import UIKit

protocol MainFactoryProtocol {
    func makeArticlesListScreen() -> ArticlesListViewController
    func makeWebViewScreen(url: URL) -> WebViewController
}

final class MainFactory: MainFactoryProtocol {
    func makeArticlesListScreen() -> ArticlesListViewController {
        let controller = ArticlesListViewController(factory: self)
        let interactor = ArticlesListInteractor(newsService: NewsService())
        let presenter = ArticlesListPresenter()

        controller.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = controller

        return controller
    }

    func makeWebViewScreen(url: URL) -> WebViewController {
        let controller = WebViewController(url: url)
        return controller
    }
}
