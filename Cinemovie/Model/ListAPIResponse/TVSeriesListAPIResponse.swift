//
//  TVSeriesListAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import Foundation

struct TVSeriesListAPIResponse: APIResponse {
    let dates: Dates?
    let page: Int
    let results: [TVSeries]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results, dates
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
