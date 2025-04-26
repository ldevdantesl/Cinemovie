//
//  TrendingPersonAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.04.2025.
//

import Foundation

struct PeopleListAPIResponse: APIResponse {
    let page: Int
    let results: [Person]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
