//
//  MovieListsAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct MovieListAPIResponse: APIResponse {
    let dates: Dates?
    let page: Int
    let movies: [Movie]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
