//
//  QueryPerson.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct Person: APIResponse {
    let id: Int
    let name: String
    let originalName: String
    let mediaType: String?
    let adult: Bool
    let popularity: Double
    let gender: Int
    let knownForDepartment: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case mediaType = "media_type"
        case adult, popularity, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}
