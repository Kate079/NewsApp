//
//  ArticlesListModel.swift
//  NewsApp
//
//  Created by Kate on 15.11.2022.
//

import Foundation

enum ArticlesListModel {
    enum LoadData {
        struct ArticlesListResponse {
            let articlesData: NewsResponse
        }
    }

    struct ArticlesListViewModel {
        let totalResults: Int
        let articles: [Article]
    }

    struct Article: Decodable {
        let source: Source
        let author: String
        let title: String
        let articleDescription: String
        let url: String
        let urlToImage: String
        let publishedAt: String
        let isItemSaved: Bool
    }

    struct Source: Decodable {
        let id: String
        let name: String
    }
}
