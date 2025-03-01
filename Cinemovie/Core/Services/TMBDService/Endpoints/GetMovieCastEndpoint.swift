//
//  GetMovieCastEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import Foundation

struct GetMovieCastEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod = .GET
    let headers: [String : String]? = [
        "Authorization" : "Bearer \(CONSTANTS.bearerToken)",
        "accept" : "application/json"
    ]
    let queryParams: [String : String]?
    let body: Data? = nil
    
    init(movieID: Int, queryParams: [String : String]? = nil){
        self.path = "/movie/\(movieID)/credits"
        self.queryParams = queryParams
    }
}
