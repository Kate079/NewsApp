//
//  NewsService.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation
import Moya

protocol NewsServiceProtocol {
    typealias HeadlinesRequestData = NewsTarget.HeadlinesRequestData
    typealias NewsRequestData = NewsTarget.NewsRequestData

    func getAllNews(
        data: NewsRequestData,
        completion: @escaping ((Result<NewsResponse, NewsError>) -> Void)
    )

    func getTopHeadlines(
        data: HeadlinesRequestData,
        completion: @escaping ((Result<NewsResponse, NewsError>) -> Void)
    )
}

class NewsService {
    // MARK: - Private properties

    private let provider = MoyaProvider<NewsTarget>()

    // MARK: - Private methods

    private func loadData<T: Decodable>(
        target: NewsTarget,
        completion: @escaping ((Result<T, NewsError>) -> Void)
    ) {
        provider.request(target) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                guard let parsedResponse = try? response.map(T.self) else {
                    return completion(.failure(.parsingError))
                }
                completion(.success(parsedResponse))
            case .failure(let error):
                guard let errorResponse = error.response else {
                    return completion(.failure(.networkError))
                }
                completion(.failure(self.failureResponse(response: errorResponse)))

            }
        }
    }

    private func failureResponse(response: Response) -> NewsError {
        var error: NewsError
        switch response.statusCode {
        case 401:
            error = .permissionDenied
        case 404:
            return .notFound
        case 429:
            return .tooManyRequests
        default:
            error = .unknownError
        }
        return error
    }
}

// MARK: - WeatherServiceProtocol

extension NewsService: NewsServiceProtocol {
    func getAllNews(
        data: NewsRequestData,
        completion: @escaping ((Result<NewsResponse, NewsError>) -> Void)
    ) {
        let target = NewsTarget.getAllNews(data, apiKey: StringConstants.apiKey)
        loadData(target: target, completion: completion)
    }

    func getTopHeadlines(
        data: HeadlinesRequestData,
        completion: @escaping ((Result<NewsResponse, NewsError>) -> Void)
    ) {
        let target = NewsTarget.topHeadlines(data, apiKey: StringConstants.apiKey)
        loadData(target: target, completion: completion)
    }
}
