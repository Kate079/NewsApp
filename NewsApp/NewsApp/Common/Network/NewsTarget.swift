//
//  NewsTarget.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import Moya

enum NewsTarget {
    struct HeadlinesRequestData {
        let country: NewsCountry?
        let category: NewsCategory?
        let sources: NewsSources?
        let searchKeyword: String?
        let page: Int?
    }

    case topHeadlines(_ data: HeadlinesRequestData, apiKey: String)
}

extension NewsTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://newsapi.org")
        else { fatalError("Unable to get url") }
        return url
    }

    var path: String {
        switch self {
        case .topHeadlines:
            return "/v2/top-headlines"
        }
    }

    var method: Moya.Method {
        switch self {
        case .topHeadlines:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .topHeadlines(let data, let apiKey):
            let parameters = prepareParametrsForRequest(
                country: data.country,
                category: data.category,
                sources: data.sources,
                searchKeyword: data.searchKeyword,
                page: data.page,
                apiKey: apiKey)
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .topHeadlines:
            return ["Content-Type": "application/json"]
        }
    }
}

extension NewsTarget {
    private func prepareParametrsForRequest(country: NewsCountry?, category: NewsCategory?, sources: NewsSources?, searchKeyword: String?, page: Int?, apiKey: String) -> [String: Any] {
        var parametrs: [String: Any] = [:]

        if let country {
            parametrs.updateValue(country.rawValue, forKey: "country")
        }
        if let category {
            parametrs.updateValue(category, forKey: "category")
        }
        if let sources {
            parametrs.updateValue(sources.rawValue, forKey: "sources")
        }
        if let searchKeyword {
            parametrs.updateValue(searchKeyword, forKey: "q")
        }
        if let page {
            parametrs.updateValue(page, forKey: "page")
        }
        parametrs.updateValue(apiKey, forKey: "apiKey")

        return parametrs
    }
}
