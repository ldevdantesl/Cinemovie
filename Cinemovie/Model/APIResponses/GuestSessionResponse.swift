//
//  GuestSessionResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.02.2025.
//

import Foundation

struct GuestSessionResponse: APIResponse {
    let success: Bool
    let guestSessionId: String
    let expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionId = "guest_session_id"
        case expiresAt = "expires_at"
    }
}
