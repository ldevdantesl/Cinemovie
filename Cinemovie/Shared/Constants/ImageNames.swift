//
//  ImageNames.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

enum ImageNames: String {
    case logoTransparent = "LogoXTransparent"
    case logoAlt = "LogoXAlt"
    case released = "Released"
    case notReleased = "NotReleased"
    case HD = "HD"
    case like = "Like"
    case share = "Share"
    case star = "Star"
    case halfStar = "HalfStar"
    
    // MARK: - LOGOS
    case imdbLogo = "IMDBLogo"
    case instaLogo = "InstagramLogo"
    case facebookLogo = "FacebookLogo"
    case twitterLogo = "TwitterLogo"
    case wikiLogo = "WikiLogo"
    case youtubeLogo = "YoutubeLogo"
    
    var identifiedSourceType: ExternalSource.SourceTypes? {
        switch self {
        case .imdbLogo: return .imdb
        case .instaLogo: return .instagram
        case .facebookLogo: return .facebook
        case .twitterLogo: return .twitter
        case .wikiLogo: return .wikipedia
        case .youtubeLogo: return .youtube
        default: return nil
        }
    }
}
