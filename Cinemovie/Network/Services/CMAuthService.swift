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
    
    // MARK: - GUEST
    func loginAsGuest() async throws
    
    // MARK: - V3 FLOW
    func createRequestTokenV3() async throws -> String
    func createSessionV3(requestToken: String) async throws
    
    // MARK: - V4 FLOW
    func createRequestTokenV4() async throws -> String
    func exchangeForAccessToken(requestToken: String) async throws
    func convertAccessTokenToSession() async throws
    
    // MARK: - LOGOUT
    func logout() async throws
}
 
final class CMAuthService: AuthServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let authContext: AuthContextProtocol
    
    var isLoggedIn: Bool { authContext.isLoggedIn }
    var isGuest: Bool { authContext.isGuest }
    
    init(httpClient: HTTPClientProtocol, authContext: AuthContextProtocol) {
        self.httpClient = httpClient
        self.authContext = authContext
    }
    
    // MARK: - GUEST
    func loginAsGuest() async throws {
        let result: GuestSessionResponse = try await httpClient.request(AuthEndpointsV3.loginAsGuest)
        authContext.sessionID = result.guestSessionId
    }
    
    // MARK: - V3 FLOW
    func createRequestTokenV3() async throws -> String {
        let result: RequestTokenResponse = try await httpClient.request(AuthEndpointsV3.createRequestToken)
        return result.requestToken
    }
    
    func createSessionV3(requestToken: String) async throws {
        let result: NewSessionResponse = try await httpClient.request(AuthEndpointsV3.createSession(requestToken: requestToken))
        authContext.sessionID = result.sessionId
        
        let account: AccountDetailsAPIResponse = try await httpClient.request(AuthEndpointsV3.getAccountDetails(sessionID: result.sessionId))
        authContext.accountID = String(account.id)
    }
    
    // MARK: - V4 FLOW
    func createRequestTokenV4() async throws -> String {
        let result: RequestTokenV4APIResponse = try await httpClient.request(AuthEndpointsV4.createRequestToken)
        return result.requestToken
    }
    
    func exchangeForAccessToken(requestToken: String) async throws {
        let result: AccessTokenAPIResponse = try await httpClient.request(AuthEndpointsV4.exchangeRequestTokenForAccessToken(requestToken: requestToken))
        authContext.accessToken = result.accessToken
        authContext.accountID = result.accountId
    }
    
    func convertAccessTokenToSession() async throws {
        guard let accessToken = authContext.accessToken else { throw APIError.unauthorized }
        let result: NewSessionResponse = try await httpClient.request(AuthEndpointsV4.convertAccessTokenToSession(accessToken: accessToken))
        authContext.sessionID = result.sessionId
    }
    
    // MARK: - LOGOUT
    func logout() async throws {
        if isGuest {
            authContext.clearSession()
        } else if let accessToken = authContext.accessToken {
            // V4 logout
            try await httpClient.request(AuthEndpointsV4.logout(accessToken: accessToken))
            authContext.clearSession()
        } else if let sessionID = authContext.sessionID {
            // V3 logout
            try await httpClient.request(AuthEndpointsV3.logOut(sessionID: sessionID))
            authContext.clearSession()
        } else {
            authContext.clearSession()
        }
    }
}
 
