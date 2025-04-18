//
//  MovieListType.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.04.2025.
//

import Foundation

enum MovieListType: MediaListType {
    case popular
    case upcoming
    case topRated
    case nowPlaying
    case animation
    case documentary
    case action
    case comedy
    case drama
    case history
    case horror
    case fantasy

    var title: String {
        switch self {
        case .popular: return "Popular Movies"
        case .upcoming: return "Upcoming Movies"
        case .topRated: return "Top Rated Movies"
        case .nowPlaying: return "Now Playing Movies"
        case .animation: return "Animation Movies"
        case .documentary: return "Documentary Movies"
        case .action: return "Action Movies"
        case .comedy: return "Comedy Movies"
        case .drama: return "Drama Movies"
        case .history: return "History Movies"
        case .horror: return "Horror Movies"
        case .fantasy: return "Fantasy Movies"
        }
    }

    var subtitle: String {
        switch self {
        case .popular: return "Trending movies everyone is watching"
        case .upcoming: return "Soon to hit screens – upcoming movies"
        case .topRated: return "Highest rated movies globally"
        case .nowPlaying: return "Movies now playing near you"
        case .animation: return "Fan-favorite animated & anime picks"
        case .documentary: return "Eye-opening documentaries"
        case .action: return "Explosive, high-octane action"
        case .comedy: return "Laugh-out-loud movie picks"
        case .drama: return "Emotionally rich dramas"
        case .history: return "Historical deep dives"
        case .horror: return "Spine-chilling horror titles"
        case .fantasy: return "Magical and mythical worlds"
        }
    }
}

enum TVSeriesListType: MediaListType {
    case popular
    case topRated
    case airingToday
    case onTheAir
    case actionAdventure
    case sciFiFantasy
    case drama
    case animation
    case crime
    case kids
    case comedy
    case documentary

    var title: String {
        switch self {
        case .popular: return "Popular TV Series"
        case .topRated: return "Top Rated TV Series"
        case .airingToday: return "Airing Today"
        case .onTheAir: return "On The Air"
        case .actionAdventure: return "Action & Adventure"
        case .sciFiFantasy: return "Sci-Fi & Fantasy"
        case .drama: return "Drama"
        case .animation: return "Animation"
        case .crime: return "Crime"
        case .kids: return "For Kids"
        case .comedy: return "Comedy"
        case .documentary: return "Documentary"
        }
    }

    var subtitle: String {
        switch self {
        case .popular: return "Trending shows everyone is watching"
        case .topRated: return "Highest rated series globally"
        case .airingToday: return "Fresh episodes airing today"
        case .onTheAir: return "Currently airing series"
        case .actionAdventure: return "Epic action & adventure shows"
        case .sciFiFantasy: return "Sci-Fi & fantasy blended content"
        case .drama: return "Emotionally rich dramas"
        case .animation: return "Animated favorites for all ages"
        case .crime: return "Gripping crime & mystery series"
        case .kids: return "Fun and safe for kids"
        case .comedy: return "Laugh-out-loud series picks"
        case .documentary: return "Eye-opening documentary series"
        }
    }
}
