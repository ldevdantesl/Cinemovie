//
//  ExternalSource.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct ExternalSource: Decodable {
    let id: Int
    let imdbID: String?
    let wikidataID: String?
    let facebookID: String?
    let instagramID: String?
    let tiktokID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdb_id"
        case wikidataID = "wikidata_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case tiktokID = "tiktok_id"
    }
}
