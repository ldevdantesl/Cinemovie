//
//  AuthenticationEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import Foundation

struct AuthenticationEndpoints {
    static let baseURL = CONSTANTS.baseURLString
    static let apiKey = CONSTANTS.apiKey
    
    static func createRequestTokenEndpoint() -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/authentication/token/new")
    }
    
    static func deleteSessionEndpoint(sessionID: String) -> Endpoint {
        let jsonBody = CMJSONSerializer.dataToJSON(json: ["session_id": sessionID])
        
        return Endpoint(
            baseURL: baseURL, apiKey: apiKey,
            path: "/authentication/session", method: .DELETE, body: jsonBody
        )
    }
    
    static func loginAsGuestEndpoint() -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/authentication/guest_session/new")
    }
    
    static func newSessionEndpoint(requestToken: String) -> Endpoint {
        let jsonBody = CMJSONSerializer.dataToJSON(json: ["request_token": requestToken])
        
        return Endpoint(
            baseURL: baseURL, apiKey: apiKey,
            path: "/authentication/session/new", method: .POST, body: jsonBody
        )
    }
    
    static func getAccountDetailsEndpoint(sessionID: String) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/account", queryParams: ["session_id" : sessionID])
    }
}
