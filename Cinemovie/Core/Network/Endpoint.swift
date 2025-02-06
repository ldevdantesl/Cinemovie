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
    var queryParams: [String : String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: String { return Constants.baseURLString }
    
    var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + path)
        
        if let queryParameters = queryParams {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
