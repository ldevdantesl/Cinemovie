//
//  AnyMedia.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 12.04.2025.
//

import Foundation

enum AnyMedia: Decodable, MediaProtocol {
    case movie(Movie)
    case tvSeries(TVSeries)

    var wrapped: MediaProtocol {
        switch self {
        case .movie(let m): return m
        case .tvSeries(let s): return s
        }
    }
    
    static func toMedia(from media: [AnyMedia]) -> [MediaProtocol] {
        return media.map { $0.wrapped }
    }
    
    var id: Int { wrapped.id }
     
    var adult: Bool? { wrapped.adult }
    
    var backdropPath: String? { wrapped.backdropPath }
    
    var genreIDS: [Int] { wrapped.genreIDS }
    
    var originalLanguage: String { wrapped.originalLanguage }
    
    var title: String { wrapped.title }
    
    var overview: String { wrapped.overview }
    
    var popularity: Double? { wrapped.popularity }
    
    var posterPath: String? { wrapped.posterPath }
    
    var voteAverage: Double? { wrapped.voteAverage }
    
    var voteCount: Int? { wrapped.voteCount }
    
    var mediaType: String? { wrapped.mediaType }
    
    var character: String? { wrapped.character }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let movie = try? container.decode(Movie.self) {
            self = .movie(movie)
        } else if let tv = try? container.decode(TVSeries.self) {
            self = .tvSeries(tv)
        } else {
            throw DecodingError.typeMismatch(
                AnyMedia.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Unknown media type")
            )
        }
    }
}
