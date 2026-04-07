//
//  SearchAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol SearchAPISubServiceProtocol {
    func getMovieSearchResults(query: String, page: Int) async throws -> [Movie]
    func getTVSeriesSearchResults(query: String, page: Int) async throws -> [TVSeries]
}

final class SearchAPISubService: SearchAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let config: APIConfigurationProtocol
    private var queryParams: [String : String] {
        [
            "language": config.language,
            "region": config.region,
            "include_adult": config.isAdultIncluded.description
        ]
    }
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol) {
        self.httpClient = httpClient
        self.config = config
    }
    
    func getMovieSearchResults(query: String, page: Int) async throws -> [Movie] {
        let response: PaginatedAPIResponse<Movie> = try await httpClient.request(SearchEndpoints.getMovieSearchResults(query: query, page: page, extraParams: queryParams))
        return response.results
    }
    
    func getTVSeriesSearchResults(query: String, page: Int) async throws -> [TVSeries] {
        let response: PaginatedAPIResponse<TVSeries> = try await httpClient.request(SearchEndpoints.getTVSeriesSearchResults(query: query, page: page, extraParams: queryParams))
        return response.results
    }
}
