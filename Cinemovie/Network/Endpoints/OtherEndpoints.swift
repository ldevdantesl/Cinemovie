//
//  OtherEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

enum OtherEndpoints: Endpoint {
    case collectionDetails(collectionID: Int, extraParams: [String: String]?)
    
    var path: String {
        switch self {
        case .collectionDetails(let collectionID, _):
            return "/collection/\(collectionID)"
        }
    }
    var method: HTTPMethod { .get }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .collectionDetails(_, let extraParams): return extraParams?.toQueryItems()
        }
    }
}
