//
//  DomainMedai.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct DomainMedia: Codable {
    let backdropPath: String?
    let id: Int
    let title, originalTitle, overview: String
    let posterPath: String?
    let mediaType: String?
    let adult: Bool
    let firstAirDate: String?
    let originalLanguage: String
    let genreIDS: [Int]
    let popularity: Double?
    let releaseDate: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character: String

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
    }
}
