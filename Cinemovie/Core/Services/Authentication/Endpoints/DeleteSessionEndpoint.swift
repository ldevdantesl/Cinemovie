//
//  DeleteSessionEndpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct DeleteSessionEndpoint: Endpoint {
    var path: String
    
    var method: HTTPMethod
    
    var headers: [String : String]?
    
    var queryParams: [String : String]?
    
    var body: Data?
    
    init(sessionId: String) {
        self.path = "/authentication/session"
        self.method = .DELETE
        self.headers = [
            "Authorization" : "Bearer \(CONSTANTS.bearerToken)",
            "accept" : "application/json",
            "content-type" : "application/json"
        ]
        self.queryParams = nil
        self.body = try? JSONSerialization.data(withJSONObject:["session_id": sessionId])
    }
}
