//
//  NewSessionResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

struct NewSessionResponse: Decodable {
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case sessionId = "session_id"
    }
}
