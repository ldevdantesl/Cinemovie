//
//  MediaAccountStatesAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import Foundation

struct MediaAccountStates: APIResponse {
    let id: Int
    let favorite: Bool
    let rated: Rated?
    let watchlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, favorite, rated, watchlist
    }
}

extension MediaAccountStates {
    struct Rated: APIResponse {
        let value: Int
    }
    
    static let empty = MediaAccountStates(id: 0, favorite: false, rated: nil, watchlist: false)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        favorite = try container.decode(Bool.self, forKey: .favorite)
        watchlist = try container.decode(Bool.self, forKey: .watchlist)
        
        if let ratedObject = try? container.decode(Rated.self, forKey: .rated) {
            rated = ratedObject
        } else {
            rated = nil
        }
    }
}
