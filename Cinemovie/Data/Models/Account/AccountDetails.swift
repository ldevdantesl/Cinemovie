//
//  AccountDetails.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

struct AccountDetails: Decodable {
    let avatar: AccountAvatar
    let id: Int
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let includeAdult: Bool
    let username: String

    enum CodingKeys: String, CodingKey {
        case avatar, id, name, username
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case includeAdult = "include_adult"
    }
}
