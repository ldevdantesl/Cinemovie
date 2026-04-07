//
//  AddOrRemoveMediaUserListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct AddOrRemoveMediaUserListResponse: Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    let results: [Result]

    struct Result: Decodable {
        let mediaType: String
        let mediaId: Int
        let success: Bool
        let error: [String]?

        enum CodingKeys: String, CodingKey {
            case mediaType = "media_type"
            case mediaId = "media_id"
            case success, error
        }
    }

    enum CodingKeys: String, CodingKey {
        case success, results
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
