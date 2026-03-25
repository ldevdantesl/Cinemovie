//
//  TMBDStatusResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct TMDBStatusResponse: Decodable {
    let id: Int?
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success, id
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
