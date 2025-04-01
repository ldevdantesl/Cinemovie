//
//  DomainVideo.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import Foundation

struct Video: APIResponse, Hashable {
    let iso639_1: String
    let iso3166_1: String
    let name, key: String
    let site: VideoWebsites
    let size: Int
    let type: VideoType
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case id, name, key, site, size, type, official
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case publishedAt = "published_at"
    }
}

enum VideoType: String, Decodable {
    case behindTheScenes = "Behind the Scenes"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}

enum VideoWebsites: String, Decodable {
    case youtube = "YouTube"
    case vimeo = "Vimeo"
}
