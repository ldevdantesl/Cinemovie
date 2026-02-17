//
//  AnyMedia.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import Foundation

enum AnyMedia: Decodable {
    case movie(Movie)
    case tvSeries(TVSeries)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let movie = try? container.decode(Movie.self) {
            self = .movie(movie)
            return
        }

        if let tv = try? container.decode(TVSeries.self) {
            self = .tvSeries(tv)
            return
        }

        throw DecodingError.typeMismatch(
            AnyMedia.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown Media type")
        )
    }
    
    static func toMedia(from anyMediaList: [AnyMedia]) -> [Media] {
        return anyMediaList.map {
            switch $0 {
            case .movie(let movie): return movie
            case .tvSeries(let series): return series
            }
        }
    }
}
