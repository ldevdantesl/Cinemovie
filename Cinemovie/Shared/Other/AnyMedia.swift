//
//  AnyMedia.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import Foundation

enum AnyMedia: Codable {
    case movie(Movie)
    case tvSeries(TVSeries)
    
    var asMedia: Media {
        switch self {
        case .movie(let m): return m
        case .tvSeries(let t): return t
        }
    }

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
    
    init(_ media: Media) {
        if let movie = media as? Movie {
            self = .movie(movie)
        } else if let tv = media as? TVSeries {
            self = .tvSeries(tv)
        } else {
            fatalError("Unsupported Media type")
        }
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
