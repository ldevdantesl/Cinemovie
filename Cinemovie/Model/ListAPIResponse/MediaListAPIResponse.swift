//
//  MediaListAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.05.2025.
//

import Foundation

struct MediaListAPIResponse: APIResponse {
    let dates: Dates?
    let page: Int
    let results: [AnyMedia]
    let totalPages: Int
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
