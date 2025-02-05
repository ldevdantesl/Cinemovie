//
//  LoginAsGuestEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.02.2025.
//

import Foundation

struct LoginAsGuestEndpoint: Endpoint {
    let path: String = "/authentication/guest_session/new"
    
    var method: HTTPMethod = .GET
    
    var headers: [String : String]? = [
        "accept": "application/json",
        "Authorization" : "Bearer \(Constants.bearerToken)"
    ]
    
    var body: Data?
}
