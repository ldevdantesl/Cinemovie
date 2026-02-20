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
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getMovieSearchResults(query: String, page: Int) async throws -> [Movie] {
        let response: PaginatedAPIResponse<Movie> = try await httpClient.request(SearchEndpoints.getMovieSearchResults(query: query, page: page))
        return response.result
    }
    
    func getTVSeriesSearchResults(query: String, page: Int) async throws -> [TVSeries] {
        let response: PaginatedAPIResponse<TVSeries> = try await httpClient.request(SearchEndpoints.getMovieSearchResults(query: query, page: page))
        return response.result
    }
}
