//
//  MediaTypes.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import Foundation

enum MediaTypes: String, Codable, CaseIterable {
    case movie = "movie"
    case tvShow = "tv"
    
    var pluralized: String {
        switch self {
        case .movie: "movies"
        case .tvShow: "tv"
        }
    }
    
    var title: String {
        switch self {
        case .movie: "Movies"
        case .tvShow: "TV Series"
        }
    }
}
