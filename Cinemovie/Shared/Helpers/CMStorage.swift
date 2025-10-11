//
//  CMStorage.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 13.06.2025.
//

import Foundation

enum CMStorage {
    static func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("CMStorage load failed for key \(key): \(error)")
            return nil
        }
    }

    static func save<T: Encodable>(_ value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("CMStorage save failed for key \(key): \(error)")
        }
    }
}
