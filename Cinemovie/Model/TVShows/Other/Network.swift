//
//  Network.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import Foundation

struct Network: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
