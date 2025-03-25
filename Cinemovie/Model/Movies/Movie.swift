//
//  QueryMovie.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct Movie: APIResponse, Media, Hashable {
    let id: Int
    let title: String
    let voteAverage: Double?
    let voteCount: Int?
    let adult: Bool?
    let backdropPath: String?
    let mediaType: String?
    let posterPath: String?
    let genreIDS: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double?
    let releaseDate: String
    let video: Bool?
    let character: String?
    let creditID: String?
    let order: Int?
    let department: String?

    enum CodingKeys: String, CodingKey {
        case adult, title, video, id, overview, popularity, character, order, department
        case creditID = "credit_id"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
