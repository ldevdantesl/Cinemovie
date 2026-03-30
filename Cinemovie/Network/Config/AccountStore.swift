//
//  AccountStoreImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

protocol AccountStoreProtocol: AuthContextProtocol {
    func clear()
}

final class CMAccountStore: AccountStoreProtocol {
    private let sessionIDKey = ConstantKeys.SESSION_ID_KEYCHAIN_KEY.rawValue
    private let accountIDKey = ConstantKeys.ACCOUNT_ID_KEYCHAIN_KEY.rawValue
    private let accessTokenKey = ConstantKeys.ACCESS_TOKEN_KEYCHAIN_KEY.rawValue
    
    private let keychainService: KeychainServiceProtocol
    
    var isLoggedIn: Bool { sessionID != nil }
    
    var sessionID: String? {
        get { keychainService.load(forKey: sessionIDKey) }
        set {
            if let value = newValue {
                keychainService.save(value, forKey: sessionIDKey)
            } else {
                keychainService.delete(forKey: sessionIDKey)
            }
        }
    }

    var accountID: String? {
        get { keychainService.load(forKey: accountIDKey) }
        set {
            if let value = newValue {
                keychainService.save(value, forKey: accountIDKey)
            } else {
                keychainService.delete(forKey: accountIDKey)
            }
        }
    }
    
    var isGuest: Bool {
        sessionID?.count == 32
    }

    var accessToken: String? {
        get { keychainService.load(forKey: accessTokenKey) }
        set {
            if let value = newValue {
                keychainService.save(value, forKey: accessTokenKey)
            } else {
                keychainService.delete(forKey: accessTokenKey)
            }
        }
    }
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    func clear() {
        sessionID = nil
        accessToken = nil
        accountID = nil
    }
    
    func clearSession() {
        clear()
    }
}
