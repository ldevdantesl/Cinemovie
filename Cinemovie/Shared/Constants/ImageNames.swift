//
//  ImageNames.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

enum ImageNames: String {
    // MARK: - GENERAL
    case logoTransparent = "LogoXTransparent"
    case logoAlt = "LogoXAlt"
    
    // MARK: - MOVIES
    case released = "Released"
    case notReleased = "NotReleased"
    case movieID = "MovieID"

    // MARK: - SHARED
    case like = "Like"
    case share = "Share"
    case star = "Star"
    case halfStar = "HalfStar"
    case HD = "HD"
    case homepage = "Homepage"
    
    // MARK: - TV
    case tvSeriesID = "TVSeriesID"
    case tvSeriesReturningStatus = "TVSeriesStatus_Returning Series"
    case tvSeriesEndedStatus = "TVSeriesStatus_Ended"
    case tvSeriesCancelledStatus = "TVSeriesStatus_Cancelled"
    case tvSeriesInProductionStatus = "TVSeriesStatus_In Production"
    case tvSeriesPlannedStatus = "TVSeriesStatus_Planned"
    case tvSeriesPilotStatus = "TVSeriesStatus_Pilot"
    case soon = "Soon"
    
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
