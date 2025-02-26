//
//  CreateRequestTokenEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct CreateRequestTokenEndpoint: Endpoint {
    let path: String = "/authentication/token/new"
    
    let method: HTTPMethod = .GET
   
    let headers: [String : String]? = [
        "Authorization" : "Bearer \(CONSTANTS.bearerToken)",
        "accept" : "application/json"
    ]
    
    let body: Data? = nil
    
    let queryParams: [String : String]? = nil
}
