//
//  BelongsToCollection.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import Foundation

struct BelongsToCollection: Codable {
    let id: Int
    let name, posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
