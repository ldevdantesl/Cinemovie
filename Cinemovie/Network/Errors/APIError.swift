//
//  APIError.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

// APIError.swift
enum APIError: Error {
    
    case invalidURL
    case encodingFailed
    
    // Network
    case noConnection
    case timeout
    case cancelled
    
    // Response
    case invalidResponse
    case statusCode(Int, Data?)
    case decodingFailed(Error)
    case noData
    
    // Auth
    case unauthorized
    
    case custom(message: String, errors: [String: [String]]?)
    
    // Unknown
    case unknown(Error)
    
    // MARK: - PROPERTIES
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .encodingFailed: return "Failed to encode request"
        case .noConnection: return "No internet connection"
        case .timeout: return "Request timed out"
        case .cancelled: return "Request cancelled"
        case .invalidResponse: return "Invalid response"
        case .statusCode(let code, _): return "HTTP error: \(code)"
        case .decodingFailed(let error): return "Decoding failed: \(error.localizedDescription)"
        case .noData: return "No data received"
        case .unauthorized: return "Unauthorized"
        case .custom(let message, _): return message
        case .unknown(let error): return error.localizedDescription
        }
    }
    
    var fieldErrors: [String: [String]]? {
        if case .custom(_, let errors) = self {
            return errors
        }
        return nil
    }
    
    var firstFieldError: String? {
        fieldErrors?.values.first?.first
    }
    
    var statusCodeValue: Int? {
        if case .statusCode(let code, _) = self {
            return code
        }
        return nil
    }
    
    var responseData: Data? {
        if case .statusCode(_, let data) = self {
            return data
        }
        return nil
    }
}
