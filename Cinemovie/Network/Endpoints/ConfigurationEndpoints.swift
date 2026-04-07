//
//  ConfigurationEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import Foundation

enum ConfigurationEndpoints: Endpoint {
    
    case countries(language: String)
    case languages
    
    var path: String {
        switch self {
        case .countries: return "/configuration/countries"
        case .languages: return "/configuration/languages"
        }
    }
    
    var auth: EndpointAuth {
        return .bearer(CONSTANTS.apiReadAcessToken)
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .countries(let language):
            return ["language" : language].toQueryItems()
        default: return .none
        }
    }
}
