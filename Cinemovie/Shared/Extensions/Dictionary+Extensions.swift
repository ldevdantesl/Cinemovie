//
//  Dictionary+Extensions.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func toQueryItems() -> [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension Dictionary where Key == String, Value == Any {
    func toQueryItems() -> [URLQueryItem] {
        map { key, value in
            let stringValue: String
            
            switch value {
            case let bool as Bool:
                stringValue = bool ? "true" : "false"
            case let string as String:
                stringValue = string
            case let int as Int:
                stringValue = String(int)
            case let double as Double:
                stringValue = String(double)
            case let float as Float:
                stringValue = String(float)
            default:
                stringValue = String(describing: value)
            }
            
            return URLQueryItem(name: key, value: stringValue)
        }
    }
}
