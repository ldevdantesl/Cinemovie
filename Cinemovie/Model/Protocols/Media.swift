//
//  Media.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import Foundation

protocol Media: Codable {
    var id: Int { get }
    var adult: Bool? { get }
    var backdropPath: String? { get }
    var genreIDS: [Int] { get }
    var originalLanguage: String { get }
    var title: String { get }
    var overview: String { get }
    var popularity: Double? { get }
    var posterPath: String? { get }
    var voteAverage: Double? { get }
    var voteCount: Int? { get }
    var mediaType: String? { get }
    var character: String? { get }
}
