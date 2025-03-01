//
//  MovieListsAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct MovieListsAPIResponse: APIResponse {
    let dates: Dates?
    let page: Int
    let movies: [QueryMovie]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum, minimum: String?
}
