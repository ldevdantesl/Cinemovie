//
//  DomainAuthorDetails.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import Foundation

struct ReviewAuthorDetails: APIResponse, Hashable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username, rating
        case avatarPath = "avatar_path"
    }
}
