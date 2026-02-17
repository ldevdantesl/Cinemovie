//
//  SourceTypes.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.04.2025.
//

import Foundation

enum SourceTypes {
    case imdb
    case wikipedia
    case facebook
    case instagram
    case tiktok
    
    var imageName: String {
        switch self {
        case .imdb: ImageNames.imdbLogo.rawValue
        case .wikipedia: ImageNames.wikiLogo.rawValue
        case .facebook: ImageNames.facebookLogo.rawValue
        case .instagram: ImageNames.instaLogo.rawValue
        case .tiktok: ImageNames.tiktokLogo.rawValue
        }
    }
}
