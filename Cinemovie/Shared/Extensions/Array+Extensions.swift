//
//  Array+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 26.04.2025.
//

import Foundation

extension Array where Element: MediaProtocol {
    func filteringHighRated(minimumRating: Double = 6.5) -> [Element] {
        self.filter { ($0.voteAverage ?? 0) > minimumRating }
    }
    
    func removingMediaWithoutPoster() -> [Element] {
        self.filter { $0.posterPath != nil }
    }
    
    func filteringByMinimumPopularity(_ minimumPopularity: Double = 7) -> [Element] {
        self.filter { ($0.popularity ?? 0) >= minimumPopularity }
    }
    
    func sortByPopularity() -> [Element] {
        self.sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
    }
}
