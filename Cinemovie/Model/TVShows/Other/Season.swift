//
//  Season.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import Foundation

struct Season: Codable {
    let airDate: String
    let episodeCount, id: Int
    let name, overview, posterPath: String
    let seasonNumber: Int
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}
