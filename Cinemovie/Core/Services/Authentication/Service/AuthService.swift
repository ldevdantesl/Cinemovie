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
    var sessionID: String? { get }
    var guestSessionID: String? { get }
    
    // MARK: - FUNCTIONS
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void)
    func loginWithOAuth(token: String, completion: @escaping (Result<String, AuthError>) -> Void) 
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void)
    func logout()
    func validateToken() -> Bool
}
