//
//  ItemStatusInUserListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct ItemStatusInUserListResponse: Decodable {
    let id: Int
    let mediaID: Int
    let mediaType: String
    let success: Bool
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case id, success
        case mediaID = "media_id"
        case mediaType = "media_type"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
