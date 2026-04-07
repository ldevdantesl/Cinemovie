//
//  MediaListAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.05.2025.
//

import Foundation

struct MediaListAPIResponse<T: MediaProtocol>: Decodable {
    let dates: Dates?
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
