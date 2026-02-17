//
//  PersonTVShowCreditsAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 21.03.2025.
//

import Foundation

public struct PersonTVShowCreditAPIResponse: APIResponse {
    let id: Int
    let cast: [TVSeries]
    let crew: [TVSeries]
}
