//
//  AlertController.swift
//  Weather
//
//  Created by Kate on 20.11.2022.
//

import Foundation
import UIKit

final class AlertController: UIAlertController {
    // MARK: - Public properties

    var tapButtonOnAlertCompletion: (() -> Void)?

    // MARK: - Lifecycle

    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.title = title
        self.message = message
    }

    // MARK: - Public methods

    func setAction(titleForButton: String) {
        self.addAction(configureAlertAction(titleForButton: titleForButton))
    }

    // MARK: - Private methods

    private func configureAlertAction(titleForButton: String) -> UIAlertAction {
        let action = UIAlertAction(title: titleForButton, style: .default) { [weak self] _ in
            self?.tapButtonOnAlertCompletion?()
        }
        return action
    }
}
