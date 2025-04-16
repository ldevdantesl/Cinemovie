//
//  TVSeasonDetails.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 15.04.2025.
//

import Foundation

struct TVSeasonDetails: APIResponse, Hashable {
    let id: Int
    let airDate: String?
    let episodes: [TVEpisode]
    let name: String
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case airDate = "air_date"
        case episodes, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}
