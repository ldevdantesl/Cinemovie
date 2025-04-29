//
//  AccountStoreImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 29.04.2025.
//

import Foundation

final class AccountStoreImpl: AccountStore {
    private let sessionIDKey = ConstantKeys.SESSION_ID_KEY.rawValue
    private let accountIDKey = ConstantKeys.ACCOUNT_ID_KEY.rawValue
    private let accessTokenKey = ConstantKeys.ACCESS_TOKEN_KEY.rawValue

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
        return sessionID != nil || accessToken != nil
    }

    func clear() {
        KeychainStore.delete(for: sessionIDKey)
        KeychainStore.delete(for: accountIDKey)
        KeychainStore.delete(for: accessTokenKey)
    }
}
