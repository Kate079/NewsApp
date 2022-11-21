//
//  ArticlesFilterViewController.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import UIKit
import RealmSwift

protocol ArticlesFilterViewControllerProtocol: AnyObject {
    func displayFilterData(viewModel: [ArticlesFilterModel])
}

class ArticlesFilterViewController: UIViewController {
    // MARK: - Public properties

    var interactor: ArticlesFilterInteractorProtocol?

    // MARK: - Private properties

    private var contentView: FilterView? {
        return view as? FilterView
    }
    private let realm = try! Realm()

    // MARK: - Lifecycle

    override func loadView() {
        view = FilterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureApplyFilterButtonCompletion()
        interactor?.setupFilerData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateSelectedFilters()
    }

    // MARK: - Private methods

    private func configureApplyFilterButtonCompletion() {
        contentView?.applyButtonCompletion = { [weak self] selectedFilters in
            guard let self = self else { return }

            try! self.realm.write {
                let filter = SelectedFilter()
                let filterDictionary = filter.filters

                for (key, value) in selectedFilters {
                    filterDictionary[key] = value
                    self.realm.add(filter)
                }
            }
            self.dismiss(animated: true)
        }
    }

    private func updateSelectedFilters() {
        let filters = realm.objects(SelectedFilter.self)
        if !filters.isEmpty {
            var parametrs: [String: String] = [:]
            filters.last?.filters.keys.forEach { key in
                if let value = filters.last?.filters.value(forKey: key) as? String {
                    parametrs.updateValue(value, forKey: key)
                }
            }
            contentView?.updateFilterWithSelectedItems(with: parametrs)
        }
    }
}

// MARK: - FilterViewControllerProtocol

extension ArticlesFilterViewController: ArticlesFilterViewControllerProtocol {
    func displayFilterData(viewModel: [ArticlesFilterModel]) {
        contentView?.configureView(with: viewModel)
    }
}
