//
//  AuthenticationAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

protocol AuthenticationAPISubServiceProtocol {
    // MARK: - V3
    func createRequestToken() async throws -> RequestTokenResponse
    func createSession(requestToken: String) async throws -> NewSessionResponse
    func loginAsGuest() async throws -> GuestSessionResponse
    func getAccountDetails(sessionID: String) async throws -> AccountDetailsAPIResponse
    func logout(sessionID: String) async throws
    
    // MARK: - V4
    func createRequestTokenV4() async throws -> RequestTokenV4APIResponse
    func exchangeForAccessToken(requestToken: String) async throws -> AccessTokenResponse
    func convertAccessTokenToSession(accessToken: String) async throws -> NewSessionResponse
    func logoutV4(accessToken: String) async throws
}

final class AuthenticationAPISubService: AuthenticationAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    // MARK: - V3
    func createRequestToken() async throws -> RequestTokenResponse {
        try await httpClient.request(AuthEndpointsV3.createRequestToken)
    }
    
    func createSession(requestToken: String) async throws -> NewSessionResponse {
        try await httpClient.request(AuthEndpointsV3.createSession(requestToken: requestToken))
    }
    
    func loginAsGuest() async throws -> GuestSessionResponse {
        try await httpClient.request(AuthEndpointsV3.loginAsGuest)
    }
    
    func getAccountDetails(sessionID: String) async throws -> AccountDetailsAPIResponse {
        try await httpClient.request(AuthEndpointsV3.getAccountDetails(sessionID: sessionID))
    }
    
    func logout(sessionID: String) async throws {
        let _: Data = try await httpClient.request(AuthEndpointsV3.logOut(sessionID: sessionID))
    }
    
    // MARK: - V4
    func createRequestTokenV4() async throws -> RequestTokenV4APIResponse {
        try await httpClient.request(AuthEndpointsV4.createRequestToken)
    }
    
    func exchangeForAccessToken(requestToken: String) async throws -> AccessTokenResponse {
        try await httpClient.request(AuthEndpointsV4.exchangeRequestTokenForAccessToken(requestToken: requestToken))
    }
    
    func convertAccessTokenToSession(accessToken: String) async throws -> NewSessionResponse {
        try await httpClient.request(AuthEndpointsV4.convertAccessTokenToSession(accessToken: accessToken))
    }
    
    func logoutV4(accessToken: String) async throws {
        let _: Data = try await httpClient.request(AuthEndpointsV4.logout(accessToken: accessToken))
    }
}
