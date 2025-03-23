//
//  PersonMediaCreditAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import Foundation

public struct PersonMovieCreditAPIResponse: APIResponse {
    let id: Int
    let cast: [Movie]
    let crew: [Movie]
}
