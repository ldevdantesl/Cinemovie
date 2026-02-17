//
//  RequestTokenResponseV4.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.05.2025.
//

import Foundation

struct RequestTokenResponseV4: APIResponse {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case requestToken = "request_token"
    }
}
