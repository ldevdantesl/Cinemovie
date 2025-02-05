//
//  RequestTokenResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct RequestTokenResponse: APIResponse {
    let success: Bool
    let expires_at: String
    let request_token: String
}
