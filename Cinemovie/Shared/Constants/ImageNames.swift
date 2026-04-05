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
    case appIcon = "AppIconImage"
    case like = "Like"
    case share = "Share"
    case star = "Star"
    case halfStar = "HalfStar"
    case HD = "HD"
    case homepage = "Homepage"
    case empty = "Empty"
    case empty2 = "Empty2"
    case notFound = "NotFound"
    case addMovie = "AddMovie"
    case completed = "Completed"
    case error = "Error"
    
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
    case tiktokLogo = "TikTokLogo"
    case wikiLogo = "WikiLogo"
}
