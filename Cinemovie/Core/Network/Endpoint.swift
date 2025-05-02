//
//  Endpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

struct Endpoint {
    
    // MARK: - PROPERTIES
    let baseURL: String
    let bearerToken: String?
    let apiKey: String?
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryParams: [String : String]?
    let body: Data?
    
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
        self.apiKey = nil
    }
    
    init(
        baseURL: String, apiKey: String,
        path: String, method: HTTPMethod = .GET,
        headers: [String : String]? = nil,
        queryParams: [String : String]? = nil,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.path = path
        self.method = method
        self.headers = headers ?? [
            "accept" : "application/json",
            "content-type" : "application/json",
            "Cache-Control" : "no-cache"
        ]
        self.queryParams = queryParams
        self.body = body
        self.bearerToken = nil
    }
    
    init(
        baseURL: String, path: String,
        method: HTTPMethod = .GET,
        headers: [String : String]? = nil,
        queryParams: [String : String]? = nil,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers ?? [
            "accept" : "application/json",
            "content-type" : "application/json",
            "Cache-Control" : "no-cache"
        ]
        self.queryParams = queryParams
        self.body = body
        self.apiKey = nil
        self.bearerToken = nil
    }
    
    // MARK: - PUBLIC PROPERTIES
    public var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + path)
        
        if let queryParameters = queryParams {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        if let apiKey = apiKey {
            if components?.queryItems == nil {
                components?.queryItems = []
            }
            components?.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
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
