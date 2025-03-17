//
//  AuthenticationEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import Foundation

struct AuthenticationEndpoints {
    static let baseURL = CONSTANTS.baseURLString
    static let bearerToken = CONSTANTS.bearerToken
    
    static func createRequestTokenEndpoint() -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/authentication/token/new")
    }
    
    static func deleteSessionEndpoint(sessionID: String) -> Endpoint {
        let jsonBody = CMJSONSerializer.dataToJSON(json: ["session_id": sessionID])
        
        return Endpoint(
            baseURL: baseURL, bearerToken: bearerToken,
            path: "/authentication/session", method: .DELETE, body: jsonBody
        )
    }
    
    static func loginAsGuestEndpoint() -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/authentication/guest_session/new")
    }
    
    static func newSessionEndpoint(requestToken: String) -> Endpoint {
        let jsonBody = CMJSONSerializer.dataToJSON(json: ["request_token": requestToken])
        
        return Endpoint(
            baseURL: baseURL, bearerToken: bearerToken,
            path: "/authentication/session/new", method: .POST, body: jsonBody
        )
    }
}
