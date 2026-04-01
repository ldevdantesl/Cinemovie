//
//  MediaAccountStates.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct MediaAccountStatesAPIResponse: Decodable {
    let id: Int
    let favorite: Bool
    let rated: Rated?
    let watchlist: Bool

    struct Rated: Decodable {
        let value: Int
    }

    static let empty = MediaAccountStatesAPIResponse(id: 0, favorite: false, rated: nil, watchlist: false)

    enum CodingKeys: String, CodingKey {
        case id, favorite, rated, watchlist
    }

    init(id: Int, favorite: Bool, rated: Rated?, watchlist: Bool) {
        self.id = id
        self.favorite = favorite
        self.rated = rated
        self.watchlist = watchlist
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        favorite = try container.decode(Bool.self, forKey: .favorite)
        watchlist = try container.decode(Bool.self, forKey: .watchlist)
        rated = try? container.decode(Rated.self, forKey: .rated)
    }
}
