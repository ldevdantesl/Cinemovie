//
//  ConfigrationLanguage.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.04.2026.
//

import Foundation

struct ConfigurationLanguage: Codable {
    let iso_639_1: String
    let englishName: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso_639_1
        case englishName = "english_name"
        case name
    }
}

extension ConfigurationLanguage {
    static let english = Self.init(iso_639_1: "en", englishName: "English", name: "English")
}
