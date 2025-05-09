//
//  DeleteAccessTokenResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.05.2025.
//

import Foundation

struct DeleteAccessTokenResponseV4: APIResponse {
    let success: Bool
    let statusMessage: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
