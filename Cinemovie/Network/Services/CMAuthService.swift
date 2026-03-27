//
//  CMAuthService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.03.2026.
//

import Foundation

protocol AuthServiceProtocol {
    var isLoggedIn: Bool { get }
    var isGuest: Bool { get }
    func loginAsGuest() async throws
    func createRequestToken() async throws -> String
    func createSession(requestToken: String) async throws
    func logout() async throws
}

final class CMAuthService: AuthServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let authContext: AuthContextProtocol
    
    var isLoggedIn: Bool { authContext.isLoggedIn }
    var isGuest: Bool { authContext.isGuest }
    
    init(networkService: NetworkServiceProtocol, authContext: AuthContextProtocol) {
        self.networkService = networkService
        self.authContext = authContext
    }
    
    func loginAsGuest() async throws {
        let result = try await networkService.auth.loginAsGuest()
        authContext.sessionID = result.guestSessionId
        authContext.isGuest = true
    }
    
    func createRequestToken() async throws -> String {
        let result = try await networkService.auth.createRequestToken()
        return result.requestToken
    }
    
    func createSession(requestToken: String) async throws {
        let result = try await networkService.auth.createSession(requestToken: requestToken)
        authContext.sessionID = result.sessionId
        authContext.isGuest = false
    }
    
    func logout() async throws {
        if isGuest {
            authContext.clearSession()
        } else {
            guard let sessionID = authContext.sessionID else { throw APIError.unauthorized }
            try await networkService.auth.logout(sessionID: sessionID )
            authContext.clearSession()
        }
    }
}
