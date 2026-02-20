//
//  HTTPClient.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol HTTPClientProtocol {
    @discardableResult
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    
    @discardableResult
    func request(_ endpoint: Endpoint) async throws -> Data
}

final class HTTPClient: HTTPClientProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger: NetworkLoggerProtocol?
    private let timeout: TimeInterval
    
    // MARK: - Init
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init(),
        timeout: TimeInterval = 30,
        logger: NetworkLoggerProtocol? = nil
    ) {
        self.session = session
        self.decoder = decoder
        self.timeout = timeout
        self.logger = logger
    }
    
    // MARK: - Public
    func request(_ endpoint: Endpoint) async throws -> Data {
        let request = try buildRequest(from: endpoint)
        let startTime = CFAbsoluteTimeGetCurrent()
        
        logger?.logRequest(request)
        
        do {
            let (data, response) = try await session.data(for: request)
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            logger?.logResponse(httpResponse, data: data, duration: duration)
            
            try validateHTTPStatus(httpResponse.statusCode, data: data)
            try validateAPIResponse(data: data)
            
            return data
        } catch let error as APIError {
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            logger?.logError(error, duration: duration)
            throw error
        } catch let error as URLError {
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            let apiError = mapURLError(error)
            logger?.logError(apiError, duration: duration)
            throw apiError
        } catch {
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            logger?.logError(error, duration: duration)
            throw APIError.unknown(error)
        }
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }

    }
    
    // MARK: - Private: Build Request
    private func buildRequest(from endpoint: Endpoint) throws -> URLRequest {
        let baseURL = endpoint.baseURL.isEmpty ? APIConstants.baseURL : endpoint.baseURL
        
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        if let queryItems = endpoint.queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = timeout
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = endpoint.body
        
        return request
    }
    
    // MARK: - Private: Validation
    private func validateHTTPStatus(_ statusCode: Int, data: Data) throws {
        guard (200...299).contains(statusCode) else {
            throw APIError.statusCode(statusCode, data)
        }
    }
    
    private func validateAPIResponse(data: Data) throws {
        struct BaseResponse: Decodable {
            let success: Bool
            let message: String?
            let errors: [String: [String]]?
        }
        
        guard let base = try? decoder.decode(BaseResponse.self, from: data) else { return }
        
        if !base.success {
            throw APIError.custom(
                message: base.message ?? "Ошибка запроса",
                errors: base.errors
            )
        }
    }
    
    // MARK: - Private: Error Mapping
    private func mapURLError(_ error: URLError) -> APIError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noConnection
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        default:
            return .unknown(error)
        }
    }
}
