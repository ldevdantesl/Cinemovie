//
//  AuthManager.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

protocol AuthService: AnyObject {
    var isLoggedIn: Bool { get }
    var oAuthToken: String? { get }
    
    func loginWithOAuth(token: String)
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void)
    func logout()
    func validateToken() -> Bool
}
