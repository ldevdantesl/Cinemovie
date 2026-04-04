//
//  SearchEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

enum SearchEndpoints: Endpoint {
    case getMovieSearchResults(query: String, page: Int)
    case getTVSeriesSearchResults(query: String, page: Int)
    
    var path: String {
        switch self {
        case .getMovieSearchResults: return "/search/movie"
        case .getTVSeriesSearchResults: return "/search/tv"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getMovieSearchResults(let query, let page), .getTVSeriesSearchResults(let query, let page):
            let queryItems = ["query" : query, "page" : page.description]
            return queryItems.toQueryItems()
        }
    }
}
