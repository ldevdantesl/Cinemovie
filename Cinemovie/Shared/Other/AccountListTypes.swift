//
//  AccountListTypes.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.05.2025.
//

import Foundation

enum AccountListTypes {
    case watchlist
    case favorite
    case rated
    
    var title: String {
        switch self {
        case .watchlist: "Watchlist"
        case .favorite: "Favorites"
        case .rated: "Rated"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .watchlist: "Added To Watchlist"
        case .favorite: "Added To Favorites"
        case .rated: nil
        }
    }
    
    var titleForEndpointsV3: String {
        switch self {
        case .watchlist: "watchlist"
        case .favorite: "favorite"
        case .rated: "rated"
        }
    }
    
    var titleForEndpointsV4: String {
        switch self {
        case .watchlist: "watchlist"
        case .favorite: "favorites"
        case .rated: "rated"
        }
    }
}
