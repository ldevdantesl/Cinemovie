//
//  UserFacingError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

struct UserFacingError {
    let title: String
    let message: String
    let isRetryable: Bool
    
    static func from(_ error: APIError) -> UserFacingError {
        UserFacingError(
            title: "Error",
            message: error.errorDescription ?? "Something went wrong",
            isRetryable: false
        )
    }
}
