//
//  ExternalSource.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct ExternalSource: APIResponse {
    let id: Int
    let freebaseMid: String?
    let freebaseID: String?
    let imdbID: String?
    let tvrageID: Int?
    let wikidataID: String?
    let facebookID: String?
    let instagramID: String?
    let tiktokID: String?
    let twitterID: String?
    let youtubeID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case freebaseMid = "freebase_mid"
        case freebaseID = "freebase_id"
        case imdbID = "imdb_id"
        case tvrageID = "tvrage_id"
        case wikidataID = "wikidata_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case tiktokID = "tiktok_id"
        case twitterID = "twitter_id"
        case youtubeID = "youtube_id"
    }
}

extension ExternalSource {
    enum SourceTypes: String {
        case imdb
        case wikipedia
        case facebook
        case instagram
        case twitter
        case youtube
    }
}
