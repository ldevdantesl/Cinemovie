//
//  AddToListResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 1.05.2025.
//

import Foundation

struct AddToAccountListResponse: APIResponse {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
