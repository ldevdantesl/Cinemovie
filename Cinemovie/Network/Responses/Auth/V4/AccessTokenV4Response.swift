//
//  AccessTokenV4Response.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

struct AccessTokenAPIResponse: Decodable {
    let accessToken: String
    let accountId: String
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accountId = "account_id"
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
