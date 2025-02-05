//
//  AuthManager.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

protocol AuthService: AnyObject {
    // MARK: - PROPERTIES
    var isLoggedIn: Bool { get }
    var oAuthToken: String? { get }
    
    // MARK: - FUNCTIONS
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void)
    func loginWithOAuth(token: String)
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void)
    func logout()
    func validateToken() -> Bool
}
