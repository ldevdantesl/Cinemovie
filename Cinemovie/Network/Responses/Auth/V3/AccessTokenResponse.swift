//
//  AccessTokenResponseV4.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct AccessTokenResponse: Decodable {
    let accountId: String
    let accessToken: String
    let success: Bool
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case success
        case accountId = "account_id"
        case accessToken = "access_token"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
