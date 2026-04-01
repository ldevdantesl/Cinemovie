//
//  KeychainStore.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation
import Security

protocol KeychainServiceProtocol {
    @discardableResult
    func save(_ data: Data, forKey key: String) -> Bool
    
    @discardableResult
    func save(_ string: String, forKey key: String) -> Bool
    
    func load(forKey key: String) -> String?
    func load(forKey key: String) -> Data?
    
    @discardableResult
    func delete(forKey key: String) -> Bool
}

final class CMKeychainService: KeychainServiceProtocol {
    
    private let serviceName: String
    
    init(serviceName: String = Bundle.main.bundleIdentifier ?? "com.app.keychain") {
        self.serviceName = serviceName
    }
    
    @discardableResult
    func save(_ data: Data, forKey key: String) -> Bool {
        delete(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func save(_ string: String, forKey key: String) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return save(data, forKey: key)
    }
    
    func load(forKey key: String) -> String? {
        guard let data: Data = load(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func load(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    @discardableResult
    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
