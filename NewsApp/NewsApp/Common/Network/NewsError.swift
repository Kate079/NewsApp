//
//  NewsError.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation

enum NewsError: Error {
    case parsingError
    case notFound
    case permissionDenied
    case unknownError
    case networkError
    case tooManyRequests

    var localizedText: String {
        switch self {
        case .parsingError:
            return "Під час завантаження даних виникла помилка. Спробуйте пізніше."
        case .notFound:
            return "Дані не знайдено."
        case .permissionDenied:
            return "Помилка доступу."
        case .unknownError:
            return "Невідома помилка сервера. Спробуйте звернутись до служби підтримки."
        case .networkError:
            return "Помилка роботи із мережею. Перевірте з'єднання."
        case .tooManyRequests:
            return "Відправлено багато запитів. Спробуйте пізніше."
        }
    }
}
