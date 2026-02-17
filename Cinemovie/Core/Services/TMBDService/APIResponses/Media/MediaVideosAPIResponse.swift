//
//  MovieVideosAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import Foundation

struct MediaVideosAPIResponse: APIResponse {
    let id: Int
    let results: [Video]
}
