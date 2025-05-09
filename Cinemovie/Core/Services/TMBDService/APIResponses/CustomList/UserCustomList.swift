//
//  UserCustomList.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import Foundation

struct UserCustomList: APIResponse {
    let accountID: String
    let adult: Bool
    let averageRating: Int?
    let createdAt: String
    let description: String?
    let featured: Int?
    let id: Int
    let iso_3166_1: String
    let iso_639_1: String
    let name: String
    let numberOfItems: Int
    let isPublic: Int
    let revenue: String?
    let runtime: Int?
    let sortBy: Int?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case accountID = "account_object_id"
        case adult
        case averageRating = "average_rating"
        case createdAt = "created_at"
        case description
        case featured
        case id
        case iso_3166_1
        case iso_639_1
        case name
        case numberOfItems = "number_of_items"
        case isPublic = "public"
        case revenue
        case runtime
        case sortBy = "sort_by"
        case updatedAt = "updated_at"
    }
}
