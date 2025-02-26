//
//  GetPopularMoviesEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct GetPopularMoviesEndpoint: Endpoint {
    let path: String = "/movie/popular"
    
    let method: HTTPMethod = .GET
    
    let headers: [String : String]? = [
        "Authorization" : "Bearer \(CONSTANTS.bearerToken)",
        "accept" : "application/json"
    ]
    
    let queryParams: [String : String]?
    
    let body: Data? = nil
    
    init(queryParams: [String : String]?) {
        self.queryParams = queryParams
    }
}
