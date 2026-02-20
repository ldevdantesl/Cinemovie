//
//  NetworkLogger.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol NetworkLoggerProtocol {
    func logRequest(_ request: URLRequest)
    func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval)
    func logError(_ error: Error, duration: TimeInterval)
}

final class CMNetworkLogger: NetworkLoggerProtocol {
    
    enum LogLevel {
        case none
        case basic
        case headers
        case body
    }
    
    private let level: LogLevel
    
    init(level: LogLevel = .basic) {
        self.level = level
    }
    
    func logRequest(_ request: URLRequest) {
        guard level != .none else { return }
        
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "NO URL"
        
        print("➡️ [\(method)] \(url)")
        
        if level == .headers || level == .body {
            request.allHTTPHeaderFields?.forEach { key, value in
                print("   📋 \(key): \(value)")
            }
        }
        
        if level == .body, let body = request.httpBody {
            printBody(body, prefix: "   📦 Request")
        }
    }
    
    func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval) {
        guard level != .none else { return }
        
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "NO URL"
        let emoji = (200...299).contains(statusCode) ? "✅" : "❌"
        let time = String(format: "%.2fms", duration * 1000)
        
        print("\(emoji) [\(statusCode)] \(url) - \(time)")
        
        if level == .headers || level == .body {
            response.allHeaderFields.forEach { key, value in
                print("   📋 \(key): \(value)")
            }
        }
        
        if level == .body {
            printBody(data, prefix: "   📦 Response")
        }
    }
    
    func logError(_ error: Error, duration: TimeInterval) {
        guard level != .none else { return }
        
        let time = String(format: "%.2fms", duration * 1000)
        print("🔴 [ERROR] \(error.localizedDescription) - \(time)")
    }
    
    // MARK: - Private
    private func printBody(_ data: Data, prefix: String) {
        if let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("\(prefix):")
            prettyString.split(separator: "\n").forEach { line in
                print("   \(line)")
            }
        } else if let string = String(data: data, encoding: .utf8) {
            print("\(prefix): \(string)")
        } else {
            print("\(prefix): \(data.count) bytes")
        }
    }
}
