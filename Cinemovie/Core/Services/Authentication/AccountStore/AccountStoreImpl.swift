//
//  AccountStoreImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

final class AccountStoreImpl: AccountStore {
    // MARK: - PRIVATE PROPERTIES
    private let sessionIDKey = ConstantKeys.SESSION_ID_KEYCHAIN_KEY.rawValue
    private let accountIDKey = ConstantKeys.ACCOUNT_ID_KEYCHAIN_KEY.rawValue
    private let accessTokenKey = ConstantKeys.ACCESS_TOKEN_KEYCHAIN_KEY.rawValue

    // MARK: - PROPERTIES
    var sessionID: String? {
        get { KeychainStore.get(for: sessionIDKey) }
        set {
            if let value = newValue {
                KeychainStore.set(value, for: sessionIDKey)
            } else {
                KeychainStore.delete(for: sessionIDKey)
            }
        }
    }

    var accountID: Int? {
        get {
            guard let string = KeychainStore.get(for: accountIDKey) else { return nil }
            return Int(string)
        }
        set {
            if let value = newValue {
                KeychainStore.set(String(value), for: accountIDKey)
            } else {
                KeychainStore.delete(for: accountIDKey)
            }
        }
    }

    var accessToken: String? {
        get { KeychainStore.get(for: accessTokenKey) }
        set {
            if let value = newValue {
                KeychainStore.set(value, for: accessTokenKey)
            } else {
                KeychainStore.delete(for: accessTokenKey)
            }
        }
    }

    var isLoggedIn: Bool {
        return sessionID != nil
    }
    
    var isGuest: Bool {
        sessionID?.count == 32
    }

    // MARK: - FUNCTIONS
    func clear() {
        KeychainStore.delete(for: sessionIDKey)
        KeychainStore.delete(for: accountIDKey)
        KeychainStore.delete(for: accessTokenKey)
    }
    
    func printEverything() {
        print("Account id: \(accountID ?? 0)")
        print("Session id: \(sessionID ?? "No sessionID")")
        print("Access Token: \(accessToken ?? "No access token")")
        print("Is logged in: \(isLoggedIn)")
        print("Is guest: \(isGuest)")
    }
}
