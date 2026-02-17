//
//  Image.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.04.2025.
//

import Foundation

struct TMDBImage: APIResponse {
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double?
    let voteCount: Int?
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height, width
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
