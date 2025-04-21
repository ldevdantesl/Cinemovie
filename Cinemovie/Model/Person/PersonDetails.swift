//
//  DomainPerson.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct PersonDetails: APIResponse {
    let id: Int
    let imdbID: String?
    let name: String
    let placeOfBirth: String?
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let knownForDepartment: String?
    let popularity: Double
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, biography, birthday, deathday, gender, homepage, id, name, popularity
        case alsoKnownAs = "also_known_as"
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
}
