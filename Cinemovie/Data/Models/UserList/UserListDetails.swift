//
//  UserListDetails.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.05.2025.
//

import Foundation

struct UserListDetails: Decodable {
    let averageRating: Double
    let backdropPath: String?
    let results: [AnyMedia]
    let createdBy: ListCreatedBy?
    let description: String
    let id: Int
    let iso3166_1: String?
    let iso639_1: String
    let itemCount: Int
    let name: String
    let page: Int
    let posterPath: String?
    let isPublic: Bool
    let revenue, runtime: Int
    let sortBy: String
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case averageRating = "average_rating"
        case backdropPath = "backdrop_path"
        case results
        case createdBy = "created_by"
        case description, id
        case iso3166_1 = "iso_3166_1"
        case iso639_1 = "iso_639_1"
        case itemCount = "item_count"
        case name
        case page
        case posterPath = "poster_path"
        case isPublic = "public"
        case revenue, runtime
        case sortBy = "sort_by"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


// MARK: - ListCreatedBy
struct ListCreatedBy: Codable {
    let avatarPath: String?
    let gravatarHash, id, name, username: String

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
        case gravatarHash = "gravatar_hash"
        case id, name, username
    }
}
