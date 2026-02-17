//
//  ItemStatusInUserListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.05.2025.
//

import Foundation

struct ItemStatusInUserListResponse: APIResponse {
    let mediaType: String
    let success: Bool
    let statusMessage: String
    let id: Int
    let mediaID: Int
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case id
        case mediaID = "media_id"
        case mediaType = "media_type"
    }
}
