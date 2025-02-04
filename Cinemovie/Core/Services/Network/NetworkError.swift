//
//  NetworkError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(String)
    case noData
    case decodingError(String)
}
