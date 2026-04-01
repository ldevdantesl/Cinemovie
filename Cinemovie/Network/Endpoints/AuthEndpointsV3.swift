//
//  AuthEndpointsV3.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

enum AuthEndpointsV3: Endpoint {
    case createRequestToken
    case createSession(requestToken: String)
    case loginAsGuest
    case getAccountDetails(sessionID: String)
    case logOut(sessionID: String)
    
    var baseURL: String {
        return CONSTANTS.baseURLString
    }
    
    var auth: EndpointAuth {
        return .apiKey(CONSTANTS.apiKey)
    }
    
    var path: String {
        switch self {
        case .createRequestToken: return "/authentication/token/new"
        case .createSession: return "/authentication/session/new"
        case .loginAsGuest: return "/authentication/guest_session/new"
        case .getAccountDetails: return "/account"
        case .logOut: return "/authentication/session"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRequestToken, .loginAsGuest, .getAccountDetails: return .get
        case .createSession: return .post
        case .logOut: return .delete
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAccountDetails(let sessionID):
            return [URLQueryItem(name: "session_id", value: sessionID)]
        default: return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .createSession(let token):
            return CMJSONSerializer.dataToJSON(json: ["request_token": token])
        case .logOut(let sessionID):
            return CMJSONSerializer.dataToJSON(json: ["session_id": sessionID])
        default: return nil
        }
    }
}
