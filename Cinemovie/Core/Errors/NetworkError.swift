//
//  NetworkError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case networkError(String)
    case noData
    case decodingError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: "Error: Invalid URL(NetworkError.invalidURL)"
        case .invalidResponse: "Error: Invalid Response(NetworkError.invalidResponse)"
        case .networkError(let string): "Error: \(string)(NetworkError.networkError)"
        case .noData: "Error: No Data(NetworkError.noData)"
        case .decodingError(let string): "Error: \(string)(NetworkError.decodingError)"
        }
    }
}
