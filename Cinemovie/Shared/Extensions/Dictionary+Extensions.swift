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
