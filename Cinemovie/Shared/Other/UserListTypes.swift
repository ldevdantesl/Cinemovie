//
//  AccountListTypes.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 4.05.2025.
//

import Foundation

enum UserListTypes {
    case watchlist
    case favorite
    case rated
    case custom(Int)
    
    var title: String {
        switch self {
        case .watchlist: "Watchlist"
        case .favorite: "Favorites"
        case .rated: "Rated"
        case .custom: "Custom"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .watchlist: "Added To Watchlist"
        case .favorite: "Added To Favorited"
        default: nil
        }
    }
}
