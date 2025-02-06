//
//  LoginAsGuestEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.02.2025.
//

import Foundation

struct LoginAsGuestEndpoint: Endpoint {
    let path: String = "/authentication/guest_session/new"
    
    let method: HTTPMethod = .GET
    
    let headers: [String : String]? = [
        "accept": "application/json",
        "Authorization" : "Bearer \(Constants.bearerToken)"
    ]
    
    let body: Data? = nil
    
    let queryParams: [String : String]? = nil
}
