//
//  CreateUserListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import Foundation

struct CreateUserListResponse: APIResponse {
    let id: Int
    let success: Bool
    let statusMessage: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case success
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
