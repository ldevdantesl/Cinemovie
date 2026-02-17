//
//  AccessTokenResponseV4.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.05.2025.
//

import Foundation

struct AccessTokenResponseV4: APIResponse {
    let accountId: String
    let accessToken: String
    let success: Bool
    let statusMessage: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case success
        case accountId = "account_id"
        case accessToken = "access_token"
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
