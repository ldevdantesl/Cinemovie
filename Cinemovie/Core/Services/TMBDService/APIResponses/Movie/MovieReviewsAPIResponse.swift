//
//  MovieReviewsAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import Foundation

// MARK: - MovieReviewsAPIResponse
struct MovieReviewsAPIResponse: APIResponse {
    let id, page: Int
    let results: [Review]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
