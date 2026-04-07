//
//  ConfigurationAPISubServce.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import Foundation

protocol ConfigurationAPISubServiceProtocol {
    func getCountries() async throws -> [ConfigurationCountry]
    func getLanguages() async throws -> [ConfigurationLanguage]
}

final class ConfigurationAPISubService: ConfigurationAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let config: APIConfigurationProtocol
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol) {
        self.httpClient = httpClient
        self.config = config
    }
    
    func getCountries() async throws -> [ConfigurationCountry] {
        try await httpClient.request(ConfigurationEndpoints.countries(language: config.language))
    }
    
    func getLanguages() async throws -> [ConfigurationLanguage] {
        try await httpClient.request(ConfigurationEndpoints.languages)
    }
}
