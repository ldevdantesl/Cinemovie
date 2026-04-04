//
//  UserListDetails.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.05.2025.
//

import Foundation

struct UserListDetails: Decodable {
    
    struct ListCreatedBy: Codable {
        let avatarPath: String?
        let gravatarHash, id, name, username: String

        enum CodingKeys: String, CodingKey {
            case avatarPath = "avatar_path"
            case gravatarHash = "gravatar_hash"
            case id, name, username
        }
    }
    
    let averageRating: Double
    let backdropPath: String?
    let results: [MediaProtocol]
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

    private enum MediaTypeCodingKey: String, CodingKey {
        case mediaType = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        averageRating = try container.decode(Double.self, forKey: .averageRating)
        backdropPath  = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        createdBy     = try container.decodeIfPresent(ListCreatedBy.self, forKey: .createdBy)
        description   = try container.decode(String.self, forKey: .description)
        id            = try container.decode(Int.self, forKey: .id)
        iso3166_1     = try container.decodeIfPresent(String.self, forKey: .iso3166_1)
        iso639_1      = try container.decode(String.self, forKey: .iso639_1)
        itemCount     = try container.decode(Int.self, forKey: .itemCount)
        name          = try container.decode(String.self, forKey: .name)
        page          = try container.decode(Int.self, forKey: .page)
        posterPath    = try container.decodeIfPresent(String.self, forKey: .posterPath)
        isPublic      = try container.decode(Bool.self, forKey: .isPublic)
        revenue       = try container.decode(Int.self, forKey: .revenue)
        runtime       = try container.decode(Int.self, forKey: .runtime)
        sortBy        = try container.decode(String.self, forKey: .sortBy)
        totalPages    = try container.decode(Int.self, forKey: .totalPages)
        totalResults  = try container.decode(Int.self, forKey: .totalResults)

        // Decode results using "media_type" to pick Movie or TVSeries
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var media: [MediaProtocol] = []
        while !resultsContainer.isAtEnd {
            let itemDecoder = try resultsContainer.superDecoder()
            let typeContainer = try itemDecoder.container(keyedBy: MediaTypeCodingKey.self)
            let mediaType = try typeContainer.decode(String.self, forKey: .mediaType)
            switch mediaType {
            case "movie":
                media.append(try Movie(from: itemDecoder))
            case "tv":
                media.append(try TVSeries(from: itemDecoder))
            default:
                break // skip unknown types silently
            }
        }
        results = media
    }
}
