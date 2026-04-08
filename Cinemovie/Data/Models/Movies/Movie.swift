//
//  QueryMovie.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

struct Movie: Codable, MediaProtocol, Hashable {
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS) ?? []
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle) ?? ""
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        video = try container.decodeIfPresent(Bool.self, forKey: .video)
        character = try container.decodeIfPresent(String.self, forKey: .character)
        creditID = try container.decodeIfPresent(String.self, forKey: .creditID)
        order = try container.decodeIfPresent(Int.self, forKey: .order)
        department = try container.decodeIfPresent(String.self, forKey: .department)
    }
}
