//
//  MovieCastAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 27.02.2025.
//

import Foundation

// MARK: - MovieCastResult
struct MovieCastAPIResponse: APIResponse {
    let id: Int
    let cast: [Cast]
    let crew: [Cast]
}
