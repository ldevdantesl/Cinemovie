//
//  MoviesAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol MoviesAPISubServiceProtocol {
    func getMovieDetails(movieID: Int) async throws -> MovieDetails
    func getMovieCast(movieID: Int) async throws -> CastAPIResponse<Cast>
    func getMovieAccountState(movieID: Int) async throws -> MediaAccountStatesAPIResponse
    func getMovieSimilar(movieID: Int) async throws -> [Movie]
    func getMovieRecommendations(movieID: Int) async throws -> [Movie]
    func getMovieReviews(movieID: Int) async throws -> [Review]
    func getMovieVideos(movieID: Int) async throws -> [Video]
    func getMovieTrending(timeWindow: TrendingTimeWindow) async throws -> [Movie]
    func getMovieList(listType: MovieListType) async throws -> [Movie]
    
    @discardableResult
    func rate(movieID: Int, value: Double) async throws -> TMDBStatusResponse
    
    @discardableResult
    func removeRating(movieID: Int) async throws -> TMDBStatusResponse
}

final class MoviesAPISubService: MoviesAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let config: APIConfigurationProtocol
    private let authContext: AuthContextProtocol
    private var queryParams: [String : String] {
        [
            "language": config.language,
            "region": config.region,
            "include_adult": config.isAdultIncluded.description
        ]
    }
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol, authContext: AuthContextProtocol) {
        self.httpClient = httpClient
        self.config = config
        self.authContext = authContext
    }
    
    func getMovieDetails(movieID: Int) async throws -> MovieDetails {
        try await httpClient.request(MovieEndpoints.details(movieID: movieID, queryParams: queryParams))
    }
    
    func getMovieCast(movieID: Int) async throws -> CastAPIResponse<Cast> {
        try await httpClient.request(MovieEndpoints.cast(movieID: movieID, queryParams: queryParams))
    }
    
    func getMovieAccountState(movieID: Int) async throws -> MediaAccountStatesAPIResponse {
        guard let sessionID = authContext.sessionID else { throw APIError.unauthorized }
        return try await httpClient.request(MovieEndpoints.accountState(movieID: movieID, sessionID: sessionID))
    }
    
    func getMovieSimilar(movieID: Int) async throws -> [Movie] {
        let response: PaginatedAPIResponse<Movie> = try await httpClient.request(MovieEndpoints.similar(movieID: movieID, queryParams: queryParams))
        return response.results
    }
    
    func getMovieRecommendations(movieID: Int) async throws -> [Movie] {
        let response: PaginatedAPIResponse<Movie> = try await httpClient.request(MovieEndpoints.recommendations(movieID: movieID, queryParams: queryParams))
        return response.results
    }
    
    func getMovieReviews(movieID: Int) async throws -> [Review] {
        let response: MediaReviewsAPIResponse = try await httpClient.request(MovieEndpoints.reviews(movieID: movieID, queryParams: queryParams))
        return response.results
    }
    
    func getMovieVideos(movieID: Int) async throws -> [Video] {
        let response: MediaVideosAPIResponse = try await httpClient.request(MovieEndpoints.videos(movieID: movieID, queryParams: queryParams))
        return response.results
    }
    
    func getMovieTrending(timeWindow: TrendingTimeWindow) async throws -> [Movie] {
        let response: PaginatedAPIResponse<Movie> =  try await httpClient.request(MovieEndpoints.trending(timeWindow: timeWindow, queryParams: queryParams))
        return response.results
    }
    
    func getMovieList(listType: MovieListType) async throws -> [Movie] {
        let response: PaginatedAPIResponse<Movie> =  try await httpClient.request(MovieEndpoints.list(listType: listType, extraParams: queryParams))
        return response.results
    }
    
    func rate(movieID: Int, value: Double) async throws -> TMDBStatusResponse {
        guard let sessionID = authContext.sessionID else { throw APIError.unauthorized }
        return try await httpClient.request(MovieEndpoints.rate(movieID: movieID, sessionID: sessionID, value: value))
    }
    
    func removeRating(movieID: Int) async throws -> TMDBStatusResponse {
        guard let sessionID = authContext.sessionID else { throw APIError.unauthorized }
        return try await httpClient.request(MovieEndpoints.removeRating(movieID: movieID, sessionID: sessionID))
    }
}
