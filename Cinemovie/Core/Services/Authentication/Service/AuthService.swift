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
    
    // MARK: - LOGIN
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void)
    func loginWithOAuth(token: String, completion: @escaping (Result<String, AuthError>) -> Void) 
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void)
    func logout()
    
    // MARK: - OTHER
    func storeAccountIDIntoAccountStore(completion: @escaping (Bool) -> Void)
    func getAccountDetails(completion: @escaping (Result<AccountDetails, AuthError>) -> Void)
    func getSessionID() 
}
