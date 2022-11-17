//
//  FilterViewController.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import UIKit

protocol AtriclesFilterViewControllerProtocol: AnyObject {
    func displayFilterData(viewModel: AtriclesFilterModel.AtriclesFilterViewModel)
}

class AtriclesFilterViewController: UIViewController {
    // MARK: - Public properties

    var router: AtriclesFilterRouterProtocol?
    var interactor: AtriclesFilterInteractorProtocol?

    // MARK: - Private properties

    private var contentView: FilterView? {
        return view as? FilterView
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = FilterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.setupFilerData()
        
        setupRouter()
        configureApplyFilterButtonCompletion()
    }

    // MARK: - Private methods

    private func setupRouter() {
        if let navigationController = navigationController {
            self.router = AtriclesFilterRouter(navigationController: navigationController)
        }
    }

    private func configureApplyFilterButtonCompletion() {
        contentView?.applyButtonCompletion = { [weak self] in
            guard let self = self else { return }

//            self.dismiss(animated: true)
        }
    }
}

// MARK: - FilterViewControllerProtocol

extension AtriclesFilterViewController: AtriclesFilterViewControllerProtocol {
    func displayFilterData(viewModel: AtriclesFilterModel.AtriclesFilterViewModel) {
        contentView?.configureView(with: viewModel)
    }
}
