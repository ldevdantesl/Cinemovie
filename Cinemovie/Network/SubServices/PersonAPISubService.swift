//
//  PersonAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol PersonAPISubServiceProtocol {
    func getPersonID(creditID: String) async throws -> CreditDetailsAPIResponse
    func images(personID: Int) async throws -> [TMDBImage]
    func externalSources(personID: Int) async throws -> ExternalSource
    func details(personID: Int) async throws -> PersonDetails
    func movieCredits(personID: Int) async throws -> CastAPIResponse<Movie>
    func tvCredits(personID: Int) async throws -> CastAPIResponse<TVSeries>
    func trending(timeWindow: TrendingTimeWindow) async throws -> [Person]
}

final class PersonAPISubService: PersonAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let config: APIConfigurationProtocol
    private var queryParams: [String : String] {
        ["language" : config.language]
    }
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol) {
        self.httpClient = httpClient
        self.config = config
    }
    
    func getPersonID(creditID: String) async throws -> CreditDetailsAPIResponse {
        try await httpClient.request(PersonEndpoints.getPersonID(creditID: creditID))
    }
    
    func images(personID: Int) async throws -> [TMDBImage] {
        let response: PersonImages = try await httpClient.request(PersonEndpoints.images(personID: personID))
        return response.profiles
    }
    
    func externalSources(personID: Int) async throws -> ExternalSource {
        try await httpClient.request(PersonEndpoints.externalSources(personID: personID))
    }
    
    func details(personID: Int) async throws -> PersonDetails {
        try await httpClient.request(PersonEndpoints.details(personID: personID, queryParams: queryParams))
    }
    
    func movieCredits(personID: Int) async throws -> CastAPIResponse<Movie> {
        try await httpClient.request(PersonEndpoints.movieCredits(personID: personID, queryParams: queryParams))
    }
    
    func tvCredits(personID: Int) async throws -> CastAPIResponse<TVSeries> {
        try await httpClient.request(PersonEndpoints.tvCredits(personID: personID, queryParams: queryParams))
    }
    
    func trending(timeWindow: TrendingTimeWindow) async throws -> [Person] {
        let response: PaginatedAPIResponse<Person> = try await httpClient.request(
            PersonEndpoints.trending(timeWindow: timeWindow, queryParams: queryParams)
        )
        return response.results
    }
}
