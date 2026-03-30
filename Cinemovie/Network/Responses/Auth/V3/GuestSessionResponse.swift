//
//  GuestSessionResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

struct GuestSessionResponse: Decodable {
    let success: Bool
    let guestSessionId: String
    let expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionId = "guest_session_id"
        case expiresAt = "expires_at"
    }
}
