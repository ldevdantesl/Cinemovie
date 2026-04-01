//
//  AuthEndpointsV4.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

enum AuthEndpointsV4: Endpoint {
    case createRequestToken
    case exchangeRequestTokenForAccessToken(requestToken: String)
    case convertAccessTokenToSession(accessToken: String)
    case logout(accessToken: String)
    
    var baseURL: String {
        switch self {
        case .convertAccessTokenToSession:
            return CONSTANTS.baseURLString
        default:
            return CONSTANTS.baseURLV4String
        }
    }
    
    var auth: EndpointAuth {
        return .bearer(CONSTANTS.apiReadAcessToken)
    }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "/auth/request_token"
        case .exchangeRequestTokenForAccessToken:
            return "/auth/access_token"
        case .convertAccessTokenToSession:
            return "/authentication/session/convert/4"
        case .logout:
            return "/auth/access_token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRequestToken,
             .exchangeRequestTokenForAccessToken,
             .convertAccessTokenToSession:
            return .post
        case .logout:
            return .delete
        }
    }
    
    var body: Data? {
        switch self {
        case .createRequestToken:
            return CMJSONSerializer.dataToJSON(json: ["redirect_to": "cinemovie://callback"])
        case .exchangeRequestTokenForAccessToken(let requestToken):
            return CMJSONSerializer.dataToJSON(json: ["request_token": requestToken])
        case .convertAccessTokenToSession(let accessToken):
            return CMJSONSerializer.dataToJSON(json: ["access_token": accessToken])
        case .logout(let accessToken):
            return CMJSONSerializer.dataToJSON(json: ["access_token": accessToken])
        }
    }
}
