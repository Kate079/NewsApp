//
//  AtriclesFilterRouter.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation
import UIKit

protocol AtriclesFilterRouterProtocol: AnyObject {
}

final class AtriclesFilterRouter {
    // MARK: - Public properties

    var navigationController: UINavigationController

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - AtriclesFilterRouterProtocol

extension AtriclesFilterRouter: AtriclesFilterRouterProtocol {
}
