//
//  MediaVideosAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct MediaVideosAPIResponse: Decodable {
    let id: Int
    let results: [Video]
}
