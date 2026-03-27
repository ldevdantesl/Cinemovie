//
//  AuthEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

enum AuthEndpoints: Endpoint {
    case createRequestToken
    case createSession(requestToken: String)
    case loginAsGuest
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
        case .logOut: return "/authentication/session"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRequestToken, .loginAsGuest: return .get
        case .createSession: return .post
        case .logOut: return .delete
        }
    }
    
    var body: Data? {
        switch self {
        case .createSession(let token):
            return CMJSONSerializer.dataToJSON(json: ["request_token": token])
        case .logOut(let sessionID):
            return CMJSONSerializer.dataToJSON(json: ["session_id" : sessionID])
        default: return nil
        }
    }
}
