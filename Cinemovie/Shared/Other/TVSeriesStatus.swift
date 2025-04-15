//
//  TVSeriesStatus.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 14.04.2025
//

import Foundation

enum TVSeriesStatus: String, Codable {
    case returningSeries = "Returning Series"
    case ended = "Ended"
    case canceled = "Canceled"
    case inProduction = "In Production"
    case planned = "Planned"
    case pilot = "Pilot"
}
