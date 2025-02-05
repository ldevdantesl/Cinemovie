//
//  CreateRequestTokenEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct CreateRequestTokenEndpoint: Endpoint {
    var path: String = "/authentication/token/new"
    
    var method: HTTPMethod = .GET
    
    var headers: [String : String]? = [
        "Authorization" : "Bearer \(Constants.bearerToken)",
        "accept" : "application/json"
    ]
    
    var body: Data?
}
