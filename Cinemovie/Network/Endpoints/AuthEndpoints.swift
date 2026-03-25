//
//  AuthEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

enum AuthEndpoints: Endpoint {
    case createRequestToken
    case requestAccessToken(requestToken: String)
    case logout(accessToken: String)
    case getSessionIDUsingAccessToken(accessToken: String)
    case loginAsGuest
    
    var baseURL: String {
        switch self {
        case .createRequestToken, .requestAccessToken, .logout:
            return CONSTANTS.baseURLV4String
        default:
            return CONSTANTS.baseURLString
        }
    }
    
    var auth: EndpointAuth {
        return .bearer(CONSTANTS.apiReadAcessToken)
    }
    
    var path: String {
        switch self {
        case .createRequestToken: return "/auth/request_token"
        case .requestAccessToken: return "/auth/access_token"
        case .logout: return "/auth/access_token"
        case .getSessionIDUsingAccessToken: return "/authentication/session/convert/4"
        case .loginAsGuest: return "/authentication/guest_session/new"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .logout: return .delete
        case .loginAsGuest: return .get
        default: return .post
        }
    }
    
    
    var body: Data? {
        switch self {
        case .createRequestToken: return CMJSONSerializer.dataToJSON(json: ["redirect_to" : "cinemovie://callback"])
        case .requestAccessToken(let requestToken): return CMJSONSerializer.dataToJSON(json: ["request_token" : requestToken])
        case .logout(let accessToken), .getSessionIDUsingAccessToken(let accessToken):
            return CMJSONSerializer.dataToJSON(json: ["access_token" : accessToken])
        case .loginAsGuest: return .none
        }
    }
}
