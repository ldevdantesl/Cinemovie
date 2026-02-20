//
//  RequestTokenResponseV4.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct RequestTokenResponse: Decodable {
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
