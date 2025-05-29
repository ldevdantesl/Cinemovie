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
    
    // MARK: - NAMES
    public func getMovieGenreNamesFromIDs(_ ids: [Int]) -> [String] {
        return ids.compactMap { id in
            movieGenres.genres.first(where: { $0.id == id })?.name
        }
    }
    
    public func getSeriesGenreNamesFromIDs(_ ids: [Int]) -> [String] {
        return ids.compactMap { id in
            tvSeriesGenres.genres.first(where: { $0.id == id })?.name
        }
    }
    
    // MARK: - IDS
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
    
    public func getSeriesGenreID(for genre: TVSeriesGenreName) -> Int {
        return tvSeriesGenres.genres.first { $0.name == genre.rawValue }?.id ?? 0
    }
}
