//
//  Endpoint.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var auth: EndpointAuth { get }
}

extension Endpoint {
    var baseURL: String { CONSTANTS.baseURLString }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
    var auth: EndpointAuth { .apiKey(CONSTANTS.apiKey) }

    var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + path)

        var allQueryItems = queryItems ?? []

        if case .apiKey(let key) = auth {
            allQueryItems.append(URLQueryItem(name: "api_key", value: key))
        }

        if !allQueryItems.isEmpty {
            components?.queryItems = allQueryItems
        }

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.cachePolicy = .reloadIgnoringLocalCacheData

        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        if case .bearer(let token) = auth {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

