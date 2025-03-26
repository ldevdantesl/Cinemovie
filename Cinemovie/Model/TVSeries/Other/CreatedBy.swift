//
//  CreatedBy.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 23.03.2025.
//

import Foundation

struct CreatedBy: Codable {
    let id: Int
    let creditID, name, originalName: String
    let gender: Int
    let profilePath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name
        case originalName = "original_name"
        case gender
        case profilePath = "profile_path"
    }
}
