//
//  AuthenticationAPISubService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

protocol AuthenticationAPISubServiceProtocol {
    func createRequestToken() async throws -> RequestTokenResponse
    func createSession(requestToken: String) async throws -> NewSessionResponse
    func loginAsGuest() async throws -> GuestSessionResponse
    func logout(sessionID: String) async throws
}

final class AuthenticationAPISubService: AuthenticationAPISubServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func createRequestToken() async throws -> RequestTokenResponse {
        try await httpClient.request(AuthEndpoints.createRequestToken)
    }
    
    func createSession(requestToken: String) async throws -> NewSessionResponse {
        try await httpClient.request(AuthEndpoints.createSession(requestToken: requestToken))
    }
    
    func loginAsGuest() async throws -> GuestSessionResponse {
        try await httpClient.request(AuthEndpoints.loginAsGuest)
    }
    
    func logout(sessionID: String) async throws {
        try await httpClient.request(AuthEndpoints.logOut(sessionID: sessionID))
    }
}
