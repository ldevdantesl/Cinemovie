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
    private let userService: UserServiceProtocol
    
    init(httpClient: HTTPClientProtocol, userService: UserServiceProtocol) {
        self.httpClient = httpClient
        self.userService = userService
    }
    
    func getCountries() async throws -> [ConfigurationCountry] {
        try await httpClient.request(ConfigurationEndpoints.countries(language: userService.userLanguage.iso_639_1))
    }
    
    func getLanguages() async throws -> [ConfigurationLanguage] {
        try await httpClient.request(ConfigurationEndpoints.languages)
    }
}
