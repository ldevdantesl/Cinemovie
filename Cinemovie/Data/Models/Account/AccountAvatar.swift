//
//  AccountAvatar.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

// MARK: - Account Avatar
struct AccountAvatar: Decodable {
    let gravatar: Gravatar?
    let tmdb: TMDBAvatar?
}

// MARK: - Gravatar
struct Gravatar: Decodable {
    let hash: String?
}

// MARK: - TMDBAvatar
struct TMDBAvatar: Decodable {
    let avatarPath: String?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
    }
}
