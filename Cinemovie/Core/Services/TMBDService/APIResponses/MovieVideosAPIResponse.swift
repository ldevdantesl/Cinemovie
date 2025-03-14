//
//  MovieVideosAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.03.2025.
//

import Foundation

struct MovieVideosAPIResponse: APIResponse {
    let id: Int
    let results: [DomainVideo]
}
