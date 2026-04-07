//
//  ConfigurationCountry.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import Foundation

struct ConfigurationCountry: Codable {
    let iso_3166_1: String
    let englishName: String
    let nativeName: String
    
    enum CodingKeys: String, CodingKey {
        case iso_3166_1
        case englishName = "english_name"
        case nativeName = "native_name"
    }
}

extension ConfigurationCountry {
    static let USA = Self.init(iso_3166_1: "US", englishName: "United States of America", nativeName: "United States")
}
