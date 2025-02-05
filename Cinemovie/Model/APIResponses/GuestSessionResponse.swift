//
//  GuestSessionResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.02.2025.
//

import Foundation

struct GuestSessionResponse: APIResponse {
    let success: Bool
    let guest_session_id: String
    let expires_at: String
}
