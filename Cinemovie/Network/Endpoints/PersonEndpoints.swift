//
//  PersonEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

enum PersonEndpoints: Endpoint {
    case getPersonID(creditID: String)
    case images(personID: Int)
    case externalSources(personID: Int)
    case details(personID: Int, queryParams: [String : String]? = nil)
    case movieCredits(personID: Int, queryParams: [String : String]? = nil)
    case tvCredits(personID: Int, queryParams: [String : String]? = nil)
    case trending(timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil)
    
    var path: String {
        switch self {
        case .getPersonID(let creditID): return "/credit/\(creditID)"
        case .details(let personID, _): return "/person/\(personID)"
        case .externalSources(let personID): return "/person/\(personID)/external_ids"
        case .movieCredits(let personID, _): return "/person/\(personID)/movie_credits"
        case .tvCredits(let personID, _): return "/person/\(personID)/tv_credits"
        case .trending(let timeWindow, _): return "/trending/person/\(timeWindow.rawValue)"
        case .images(let personID): return "/person/\(personID)/images"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .details(_, let queryParams): return queryParams?.toQueryItems()
        case .movieCredits(_, let queryParams): return queryParams?.toQueryItems()
        case .tvCredits(_, let queryParams): return queryParams?.toQueryItems()
        case .trending(_, let queryParams): return queryParams?.toQueryItems()
        default:
            return .none
        }
    }
}
