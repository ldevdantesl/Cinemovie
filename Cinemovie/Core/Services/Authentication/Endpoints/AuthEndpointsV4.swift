//
//  AuthEndpointsV4.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.05.2025.
//

import Foundation

struct AuthEndpointsV4 {
    private static let baseURLV4 = CONSTANTS.baseURLV4String
    private static let baseURLV3 = CONSTANTS.baseURLString
    private static let apiReadAccessToken = CONSTANTS.apiReadAcessToken
    
    static func createRequestTokenEndpoint() -> Endpoint {
        let body = CMJSONSerializer.dataToJSON(json: ["redirect_to" : "cinemovie://callback"])
        return Endpoint(baseURL: baseURLV4, bearerToken: apiReadAccessToken, path: "/auth/request_token", method: .POST, body: body)
    }
    
    static func requestAccessTokenEndpoint(requestToken: String) -> Endpoint {
        let body = CMJSONSerializer.dataToJSON(json: ["request_token" : requestToken])
        return Endpoint(baseURL: baseURLV4, bearerToken: apiReadAccessToken, path: "/auth/access_token", method: .POST, body: body)
    }
    
    static func logOutEndpoint(accessToken: String) -> Endpoint {
        let body = CMJSONSerializer.dataToJSON(json: ["access_token" : accessToken])
        return Endpoint(baseURL: baseURLV4, bearerToken: apiReadAccessToken, path: "/auth/access_token", method: .DELETE, body: body)
    }
    
    static func getSessionIDUsingAccessTokenEndpoint(accessToken: String) -> Endpoint {
        let body = CMJSONSerializer.dataToJSON(json: ["access_token" : accessToken])
        return Endpoint(baseURL: baseURLV3, bearerToken: apiReadAccessToken, path: "/authentication/session/convert/4", method: .POST, body: body)
    }
}
