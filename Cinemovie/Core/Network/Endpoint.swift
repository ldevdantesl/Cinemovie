//
//  Endpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

struct Endpoint {
   
    // MARK: - PRIVATE PROPERTIES
    private let baseURL: String
    private let bearerToken: String
    private let path: String
    private let method: HTTPMethod
    private let headers: [String: String]?
    private let queryParams: [String : String]?
    private let body: Data?
    
    // MARK: - INIT
    init(
        baseURL: String, bearerToken: String,
        path: String, method: HTTPMethod = .GET,
        headers: [String : String]? = nil,
        queryParams: [String : String]? = nil,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.bearerToken = bearerToken
        self.path = path
        self.method = method
        self.headers = headers ?? [
            "Authorization" : "Bearer \(bearerToken)",
            "accept" : "application/json",
            "content-type" : "application/json",
            "Cache-Control" : "no-cache"
        ]
        self.queryParams = queryParams
        self.body = body
    }
    
    // MARK: - PUBLIC PROPERTIES
    public var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + path)
        
        if let queryParameters = queryParams {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }
}
