//
//  AddOrRemoveMediaUserListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.05.2025.
//

import Foundation

struct AddOrRemoveMediaUserListResponse: APIResponse {
    let statusMessage: String
    let results: [AddOrRemoveMediaUserListResult]
    let success: Bool
    let statusCode: Int
    
    struct AddOrRemoveMediaUserListResult: APIResponse {
        let mediaType: String
        let mediaId: Int
        let success: Bool
        
        enum CodingKeys: String, CodingKey {
            case mediaType = "media_type"
            case mediaId = "media_id"
            case success
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case results
        case success
        case statusCode = "status_code"
    }
}
