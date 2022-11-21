//
//  ArticlesFilterModel.swift
//  NewsApp
//
//  Created by Kate on 17.11.2022.
//

import Foundation
import RealmSwift

struct ArticlesFilterModel {
    let title: String
    let filter: [String]
}

class SelectedFilter: Object {
    let filters = Map<String, String>()
}
