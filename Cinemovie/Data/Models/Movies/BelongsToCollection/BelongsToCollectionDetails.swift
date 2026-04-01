//
//  BelongsToCollectionDetails.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import Foundation

struct BelongsToCollectionDetails: Decodable {
    let id: Int
    let name: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let parts: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, parts
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
