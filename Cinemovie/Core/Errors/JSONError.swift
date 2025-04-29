//
//  JSONError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

enum JSONError: Error {
    case failedSerialization
    case failedDeserialization
    case failedDecoding
    case failedEncoding
    
    var localizedDescription: String {
        switch self {
        case .failedSerialization: "Failed Serializing Data"
        case .failedDeserialization: "Failed Deserializing Data"
        case .failedDecoding: "Failed Decoding"
        case .failedEncoding: "Failed Encoding"
        }
    }
}
