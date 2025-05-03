//
//  AnyMedia.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import Foundation

enum AnyMedia: Media, Decodable {
    var id: Int {
        switch self {
        case .movie(let movie): return movie.id
        case .tvSeries(let tv): return tv.id
        }
    }
    
    var adult: Bool? {
        switch self {
        case .movie(let movie): movie.adult
        case .tvSeries(let tVSeries): tVSeries.adult
        }
    }
    
    var backdropPath: String? {
        switch self {
        case .movie(let movie): movie.backdropPath
        case .tvSeries(let tVSeries): tVSeries.backdropPath
        }
    }
    
    var genreIDS: [Int] {
        switch self {
        case .movie(let movie): movie.genreIDS
        case .tvSeries(let tVSeries): tVSeries.genreIDS
        }
    }
    
    var originalLanguage: String {
        switch self {
        case .movie(let movie): movie.originalLanguage
        case .tvSeries(let tVSeries): tVSeries.originalLanguage
        }
    }
    
    var overview: String {
        switch self {
        case .movie(let movie): movie.overview
        case .tvSeries(let tVSeries): tVSeries.overview
        }
    }
    
    var popularity: Double? {
        switch self {
        case .movie(let movie): movie.popularity
        case .tvSeries(let tVSeries): tVSeries.popularity
        }
    }
    
    var posterPath: String? {
        switch self {
        case .movie(let movie): movie.posterPath
        case .tvSeries(let tVSeries): tVSeries.posterPath
        }
    }
    
    var voteAverage: Double? {
        switch self {
        case .movie(let movie): movie.voteAverage
        case .tvSeries(let tVSeries): tVSeries.voteAverage
        }
    }
    
    var voteCount: Int? {
        switch self {
        case .movie(let movie): movie.voteCount
        case .tvSeries(let tVSeries): tVSeries.voteCount
        }
    }
    
    var mediaType: String? {
        switch self {
        case .movie(let movie): movie.mediaType
        case .tvSeries(let tVSeries): tVSeries.mediaType
        }
    }
    
    var character: String? {
        switch self {
        case .movie(let movie): movie.character
        case .tvSeries(let tVSeries): tVSeries.character
        }
    }
    
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
}
