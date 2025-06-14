//
//  QueryTVShow.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import Foundation

struct TVSeries: Media, APIResponse, Encodable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double?
    let posterPath: String?
    let firstAirDate: String
    let title: String
    let voteAverage: Double?
    let voteCount: Int?
    let character: String?
    let creditID: String?
    let department: String?
    let mediaType: String?
    let job: String?
    let episodeCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, adult, character, department, job, overview, popularity
        case title = "name"
        case mediaType = "media_type"
        case episodeCount = "episode_count"
        case creditID = "credit_id"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
