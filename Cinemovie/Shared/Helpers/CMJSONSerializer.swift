//
//  CMJSONSerializer.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import Foundation

struct CMJSONSerializer {
    static func dataToJSON(json: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: json)
    }
}
