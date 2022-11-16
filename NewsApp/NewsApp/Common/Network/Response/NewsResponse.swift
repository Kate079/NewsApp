//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation

// MARK: - NewsResponse

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source

struct Source: Decodable {
    let id: String?
    let name: String
}
