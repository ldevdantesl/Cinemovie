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
    
    private enum CodingKeys: String, CodingKey {
        case type, value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .movie(let movie):
            try container.encode("movie", forKey: .type)
            try container.encode(movie, forKey: .value)
        case .tvSeries(let tv):
            try container.encode("tv", forKey: .type)
            try container.encode(tv, forKey: .value)
        }
    }

    init(from decoder: Decoder) throws {
        if let keyed = try? decoder.container(keyedBy: CodingKeys.self),
           let type = try? keyed.decode(String.self, forKey: .type) {
            switch type {
            case "movie":
                let movie = try keyed.decode(Movie.self, forKey: .value)
                self = .movie(movie)
                return
            case "tv":
                let tv = try keyed.decode(TVSeries.self, forKey: .value)
                self = .tvSeries(tv)
                return
            default:
                break
            }
        }
        
        let single = try decoder.singleValueContainer()
        if let movie = try? single.decode(Movie.self) {
            self = .movie(movie)
            return
        }
        if let tv = try? single.decode(TVSeries.self) {
            self = .tvSeries(tv)
            return
        }
        
        throw DecodingError.typeMismatch(
            AnyMedia.self,
            .init(codingPath: decoder.codingPath,
                  debugDescription: "Unknown Media type")
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
