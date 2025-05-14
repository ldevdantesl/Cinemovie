//
//  UserCustomList.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import Foundation

struct UserList: APIResponse {
    let accountID: String
    let adult: Int
    let averageRating: Double
    let backdropPath: String?
    let createdAt: String
    let description: String?
    let featured: Int
    let id: Int
    let iso3166_1: String?
    let iso639_1: String
    let name: String
    let numberOfItems: Int
    let posterPath: String?
    let isPublic: Int
    let revenue: Int
    let runtime: String
    let sortBy: Int
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case accountID = "account_object_id"
        case adult
        case averageRating = "average_rating"
        case backdropPath = "backdrop_path"
        case createdAt = "created_at"
        case description, featured, id
        case iso3166_1 = "iso_3166_1"
        case iso639_1 = "iso_639_1"
        case name
        case numberOfItems = "number_of_items"
        case posterPath = "poster_path"
        case isPublic = "public"
        case revenue, runtime
        case sortBy = "sort_by"
        case updatedAt = "updated_at"
    }
}
