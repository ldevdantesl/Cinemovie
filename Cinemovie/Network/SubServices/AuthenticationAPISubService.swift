//
//  AuthenticationAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

protocol AuthenticationAPISubServiceProtocol {
    var isLoggedIn: Bool { get }
    func createRequestToken() async throws -> RequestTokenResponse
    func exchangeRequestToAccessToken(token: String) async throws -> AccessTokenResponse
    func getSessionIDUsingAccessToken(token: String) async throws -> NewSessionResponse
    
    @discardableResult
    func loginAsGuest() async throws -> GuestSessionResponse
    func logout() async throws
    
}

final class AuthenticationAPISubService: AuthenticationAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let authContext: AuthContextProtocol
    
    var isLoggedIn: Bool {
        authContext.isLoggedIn
    }
    
    init(httpClient: HTTPClientProtocol, authContext: AuthContextProtocol) {
        self.httpClient = httpClient
        self.authContext = authContext
    }
    
    func createRequestToken() async throws -> RequestTokenResponse {
        try await httpClient.request(AuthEndpoints.createRequestToken)
    }
    
    func exchangeRequestToAccessToken(token: String) async throws -> AccessTokenResponse {
        try await httpClient.request(AuthEndpoints.requestAccessToken(requestToken: token))
    }
    
    func getSessionIDUsingAccessToken(token: String) async throws -> NewSessionResponse {
        try await httpClient.request(AuthEndpoints.getSessionIDUsingAccessToken(accessToken: token))
    }
    
    func loginAsGuest() async throws -> GuestSessionResponse {
        try await httpClient.request(AuthEndpoints.loginAsGuest)
    }
    
    func logout() async throws {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        try await httpClient.request(AuthEndpoints.logout(accessToken: accessToken))
    }
}
