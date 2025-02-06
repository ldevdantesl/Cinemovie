//
//  NewSessionEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct NewSessionEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String : String]?
    let body: Data?
    let queryParams: [String : String]?
    
    init(body: [String : Any]) {
        self.path = "/authentication/session/new"
        self.method = .POST
        self.headers = [
            "Authorization" : "Bearer \(Constants.bearerToken)",
            "accept" : "application/json",
            "content-type" : "application/json"
        ]
        self.body = try? JSONSerialization.data(withJSONObject: body)
        self.queryParams = nil
    }
}
