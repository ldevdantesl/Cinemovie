//
//  TVSeriesAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol TVSeriesAPISubServiceProtocol {
    func getDetails(seriesID: Int) async throws -> TVSeriesDetails
    func getAccountState(seriesID: Int, sessionID: String) async throws -> MediaAccountStatesAPIResponse
    func getCast(seriesID: Int) async throws -> CastAPIResponse<Cast>
    func getVideos(seriesID: Int) async throws -> MediaVideosAPIResponse
    func getReviews(seriesID: Int) async throws -> MediaReviewsAPIResponse
    func getSimilar(seriesID: Int) async throws -> [TVSeries]
    func getRecommendations(seriesID: Int) async throws -> [TVSeries]
    func getTrending(timeWindow: TrendingTimeWindow) async throws -> [TVSeries]
    func getSeasonDetails(seriesID: Int, seasonNumber: Int) async throws -> TVSeasonDetails
    func getList(listType: TVSeriesListType) async throws -> [TVSeries]
}

final class TVSeriesAPISubService: TVSeriesAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let config: APIConfigurationProtocol
    private var queryParams: [String : String] {
        ["language" : config.language]
    }
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol) {
        self.httpClient = httpClient
        self.config = config
    }
    
    func getDetails(seriesID: Int) async throws -> TVSeriesDetails {
        try await httpClient.request(TVSeriesEndpoints.details(seriesID: seriesID, queryParams: queryParams))
    }
    
    func getAccountState(seriesID: Int, sessionID: String) async throws -> MediaAccountStatesAPIResponse {
        try await httpClient.request(TVSeriesEndpoints.accountState(seriesID: seriesID, sessionID: sessionID))
    }
    
    func getCast(seriesID: Int) async throws -> CastAPIResponse<Cast> {
        try await httpClient.request(TVSeriesEndpoints.cast(seriesID: seriesID, queryParams: queryParams))
    }
    
    func getVideos(seriesID: Int) async throws -> MediaVideosAPIResponse {
        try await httpClient.request(TVSeriesEndpoints.videos(seriesID: seriesID, queryParams: queryParams))
    }
    
    func getReviews(seriesID: Int) async throws -> MediaReviewsAPIResponse {
        try await httpClient.request(TVSeriesEndpoints.reviews(seriesID: seriesID, queryParams: queryParams))
    }
    
    func getSimilar(seriesID: Int) async throws -> [TVSeries] {
        let response: PaginatedAPIResponse<TVSeries> = try await httpClient.request(TVSeriesEndpoints.similar(seriesID: seriesID, queryParams: queryParams))
        return response.result
    }
    
    func getRecommendations(seriesID: Int) async throws -> [TVSeries] {
        let response: PaginatedAPIResponse<TVSeries> = try await httpClient.request(TVSeriesEndpoints.recommendations(seriesID: seriesID, queryParams: queryParams))
        return response.result
    }
    
    func getTrending(timeWindow: TrendingTimeWindow) async throws -> [TVSeries] {
        let response: PaginatedAPIResponse<TVSeries> = try await httpClient.request(TVSeriesEndpoints.trending(timeWindow: timeWindow, queryParams: queryParams))
        return response.result
    }
    
    func getSeasonDetails(seriesID: Int, seasonNumber: Int) async throws -> TVSeasonDetails {
        try await httpClient.request(TVSeriesEndpoints.seasonDetails(seriesID: seriesID, seasonNumber: seasonNumber, queryParams: queryParams))
    }
    
    func getList(listType: TVSeriesListType) async throws -> [TVSeries] {
        let response: PaginatedAPIResponse<TVSeries> = try await httpClient.request(TVSeriesEndpoints.list(listType: listType, extraParams: queryParams))
        return response.result
    }
}
