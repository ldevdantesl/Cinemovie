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

    var accountID: String? {
        get { KeychainStore.get(for: accountIDKey) }
        set {
            if let value = newValue {
                KeychainStore.set(value, for: accountIDKey)
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
        self.sessionID = nil
        self.accessToken = nil
        self.accountID = nil
    }
    
    func printEverything() {
        print("Account id: \(accountID ?? "")")
        print("Session id: \(sessionID ?? "No sessionID")")
        print("Access Token: \(accessToken ?? "No access token")")
        print("Is logged in: \(isLoggedIn)")
        print("Is guest: \(isGuest)")
    }
}
