//
//  AuthServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

final class AuthServiceImpl: AuthService {
    private let oAuthTokenKey = "oAuthTokenKey"
    private let isGuestUserKey = "isGuestUserKey"
    
    var isLoggedIn: Bool {
        return oAuthToken != nil || isGuestUser
    }
    
    var isGuestUser: Bool {
        return UserDefaults.standard.bool(forKey: isGuestUserKey)
    }
    
    var oAuthToken: String? {
        return UserDefaults.standard.string(forKey: oAuthTokenKey)
    }
    
    func loginWithOAuth(token: String) {
        UserDefaults.standard.set(token, forKey: oAuthTokenKey)
        UserDefaults.standard.set(false, forKey: isGuestUserKey)
    }
    
    func loginAsGuest() {
        UserDefaults.standard.removeObject(forKey: oAuthTokenKey)
        UserDefaults.standard.set(true, forKey: isGuestUserKey)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: oAuthTokenKey)
        UserDefaults.standard.set(false, forKey: isGuestUserKey)
    }
    
    func validateToken() -> Bool {
        guard let token = oAuthToken else { return false }
        return !token.isEmpty
    }
}
