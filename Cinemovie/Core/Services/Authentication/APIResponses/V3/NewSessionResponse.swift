//
//  NewSessionResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct NewSessionResponse: APIResponse {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case sessionId = "session_id"
    }
}
