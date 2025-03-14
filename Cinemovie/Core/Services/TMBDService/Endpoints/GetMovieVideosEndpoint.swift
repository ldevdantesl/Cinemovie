//
//  GetMovieVideosEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import Foundation

struct GetMovieVideosEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod = .GET
    let headers: [String : String]? = [
        "Authorization" : "Bearer \(CONSTANTS.bearerToken)",
        "accept" : "application/json"
    ]
    let queryParams: [String : String]?
    let body: Data? = nil
    
    init(movieID: Int, queryParams: [String : String]?) {
        self.path = "/movie/\(movieID)/videos"
        self.queryParams = queryParams
    }
}
