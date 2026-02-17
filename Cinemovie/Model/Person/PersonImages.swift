//
//  PersonImages.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 28.04.2025.
//

import Foundation

struct PersonImages: APIResponse {
    let id: Int
    let profiles: [TMDBImage]
}
