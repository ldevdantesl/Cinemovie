//
//  RequestTokenV4Response.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

struct RequestTokenV4APIResponse: Decodable {
    let statusMessage: String
    let requestToken: String
    let success: Bool
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case requestToken = "request_token"
        case success
        case statusCode = "status_code"
    }
}
