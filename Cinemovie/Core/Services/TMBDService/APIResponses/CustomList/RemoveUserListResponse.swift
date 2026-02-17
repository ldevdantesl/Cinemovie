//
//  RemoveUserListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.05.2025.
//

import Foundation
struct RemoveUserListResponse: APIResponse {
    let success: Bool
    let statusMessage: String
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
