//
//  CustomTableViewCell.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import UIKit

final class CustomTableViewCell: UITableViewCell {
    // MARK: - Static properties

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.tintColor = .gray
        imageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var accessoryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(accessoryButtonDidTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Private properties

    private var isAccessoryButtonSelected: Bool? {
        didSet {
            accessoryButtonSelectedCompletion?(isAccessoryButtonSelected)
        }
    }

    // MARK: - Public properties

    var accessoryButtonSelectedCompletion: ((Bool?) -> Void)?

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .clear

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(customImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(accessoryButton)

        NSLayoutConstraint.activate([
            customImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.mediumEdgeInset),
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumEdgeInset),
            customImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            customImageView.widthAnchor.constraint(equalTo: customImageView.heightAnchor),

            accessoryButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.mediumEdgeInset),
            accessoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.mediumEdgeInset)),
            accessoryButton.heightAnchor.constraint(equalToConstant: Constants.accessoryImageHeight),
            accessoryButton.widthAnchor.constraint(equalTo: accessoryButton.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.mediumEdgeInset),
            titleLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: Constants.mediumEdgeInset),
            titleLabel.trailingAnchor.constraint(equalTo: accessoryButton.leadingAnchor, constant: -(Constants.smallEdgeInset)),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.smallEdgeInset),
            subtitleLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: Constants.mediumEdgeInset),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.mediumEdgeInset)),

            contentLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: Constants.smallEdgeInset),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumEdgeInset),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Constants.mediumEdgeInset)),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(Constants.mediumEdgeInset))
        ])
    }

    private func setImage(_ urlToImage: String?) {
        guard let urlToImage, let url = URL(string: urlToImage) else { return }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.customImageView.image = UIImage(data: imageData)
                }
            }
        }
    }

    @objc private func accessoryButtonDidTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            sender.setImage(UIImage(systemName: "bookmark.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        } else {
            sender.setImage(UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        isAccessoryButtonSelected = sender.isSelected
    }

    // MARK: - Public methods

    func configure(_ item: ArticlesListModel.Article) {
        titleLabel.text = item.title
        subtitleLabel.text = "\(item.source.name) / \(item.author)"
        contentLabel.text = item.articleDescription
        setImage(item.urlToImage)
    }
}

// MARK: - Layout constants

extension CustomTableViewCell {
    private struct Constants {
        static let cornerRadius: CGFloat = 16
        static let smallEdgeInset: CGFloat = 8
        static let mediumEdgeInset: CGFloat = 16
        static let accessoryImageHeight: CGFloat = 24
    }
}
