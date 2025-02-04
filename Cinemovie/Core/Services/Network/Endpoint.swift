//
//  Endpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: String { return "https://api.example.com" }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
