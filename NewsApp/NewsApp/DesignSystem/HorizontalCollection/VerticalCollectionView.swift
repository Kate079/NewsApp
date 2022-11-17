//
//  VerticalCollectionView.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation
import UIKit

final class VerticalCollectionView: UIView {
    // MARK: - Subviews

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier)
        collectionView.register(VerticalCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VerticalCollectionViewHeader.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Private properties

    private var configurationData: AtriclesFilterModel.AtriclesFilterViewModel?

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Public methods

    func configureView(with data: AtriclesFilterModel.AtriclesFilterViewModel) {
        configurationData = data
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension VerticalCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return configurationData?.title.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let configurationData else { return 0 }
        switch section {
        case 0:
            return configurationData.category.count
        case 1:
            return configurationData.country.count
        default:
            return configurationData.sources.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier, for: indexPath) as? VerticalCollectionViewCell
        else { return UICollectionViewCell() }

        if let configurationData = configurationData {
            switch indexPath.section {
            case 0:
                cell.configure(configurationData.category[indexPath.item])
            case 1:
                cell.configure(configurationData.country[indexPath.item])
            default:
                cell.configure(configurationData.sources[indexPath.item])
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VerticalCollectionViewHeader.reuseIdentifier, for: indexPath) as? VerticalCollectionViewHeader else {
            return UICollectionReusableView()
        }
        if let configurationData = configurationData {
            header.configure(with: configurationData.title[indexPath.section])
        }
            return header
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension VerticalCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.bounds.size.width / 3.5)
        let height = Int(width / 2)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.smallEdgeInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.mediumEdgeInset, left: Constants.mediumEdgeInset, bottom: Constants.mediumEdgeInset, right: Constants.mediumEdgeInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constants.headerHeight)
    }
}

// MARK: - Layout constants

extension VerticalCollectionView {
    private struct Constants {
        static let cornerRadius: CGFloat = 16
        static let smallEdgeInset: CGFloat = 8
        static let mediumEdgeInset: CGFloat = 16
        static let edgeInset: CGFloat = 32
        static let cellHeight: CGFloat = 24
        static let headerHeight: CGFloat = 40
    }
}
