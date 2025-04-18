//
//  GenreHelper.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.04.2025.
//

import Foundation

final class GenreHelper {
    // MARK: - SINGLETON
    static let shared = GenreHelper()
    
    // MARK: - PROPERTIES
    public let movieGenres: MediaGenre
    public let tvSeriesGenres: MediaGenre
    
    // MARK: - INIT
    private init() {
        self.movieGenres = Bundle.main.decode(FileNames.jsonMovieGenres)
        self.tvSeriesGenres = Bundle.main.decode(FileNames.jsonTVGenres)
    }
    
    // MARK: - PUBLIC FUNC
    public func getMoviesGenreIDsSeparatedByComma(genres: [MovieGenreName]) -> String {
        let ids = genres.compactMap { name in
            movieGenres.genres.first(where: { $0.name == name.rawValue })?.id
        }
        return ids.map(String.init).joined(separator: ",")
    }

    public func getTVSeriesGenreIDsSeperatedByComma(genres: [TVSeriesGenreName]) -> String {
        let ids = genres.compactMap { name in
            tvSeriesGenres.genres.first(where: { $0.name == name.rawValue })?.id
        }
        return ids.map(String.init).joined(separator: ",")
    }
    
    public func getMovieGenreID(for genre: MovieGenreName) -> Int {
        return movieGenres.genres.first { $0.name == genre.rawValue }?.id ?? 0
    }
}
