//
//  AnyMedia.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import Foundation

enum AnyMedia: Decodable {
    case movie(Movie)
    case tv(TVSeries)

    var value: Media {
        switch self {
        case .movie(let movie): return movie
        case .tv(let tvSeries): return tvSeries
        }
    }

    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .mediaType)
        
        switch typeString {
        case "movie": self = .movie(try Movie(from: decoder))
        case "tv": self = .tv(try TVSeries(from: decoder))
        default: throw DecodingError.dataCorruptedError(forKey: .mediaType, in: container, debugDescription: "Unknown media type")
        }
    }
}
