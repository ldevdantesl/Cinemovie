//
//  PersonCreditAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct CastAPIResponse<T: Decodable>: Decodable {
    let id: Int
    let cast: [T]
    let crew: [T]
}
