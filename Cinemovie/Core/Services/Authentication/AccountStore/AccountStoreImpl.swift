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
    private let guestSessionIDKey = ConstantKeys.GUEST_SESSION_ID_KEYCHAIN_KEY.rawValue
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
    
    var guestSessionID: String? {
        get { KeychainStore.get(for: guestSessionIDKey) }
        set {
            if let newValue = newValue {
                KeychainStore.set(newValue, for: guestSessionIDKey)
            } else {
                KeychainStore.delete(for: sessionIDKey)
            }
        }
    }

    var accountObjectID: String? {
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
        return sessionID != nil || guestSessionID != nil
    }
    
    var isGuest: Bool {
        return guestSessionID != nil
    }

    // MARK: - FUNCTIONS
    func clear() {
        KeychainStore.delete(for: sessionIDKey)
        KeychainStore.delete(for: accountIDKey)
        KeychainStore.delete(for: accessTokenKey)
    }
}
