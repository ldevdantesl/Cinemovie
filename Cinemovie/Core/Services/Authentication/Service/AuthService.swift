//
//  AuthManager.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

protocol AuthService: AnyObject {
    var isLoggedIn: Bool { get }
    
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void)
    func logout()
}

protocol AuthServiceV3: AuthService {
    // MARK: - LOGIN
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void)
    func exchangeRequestToSession(token: String, completion: @escaping (Result<String, AuthError>) -> Void)
    
    // MARK: - OTHER
    func storeAccountIDIntoAccountStore(completion: @escaping (Bool) -> Void)
    func getAccountDetails(completion: @escaping (Result<AccountDetails, AuthError>) -> Void)
    func getSessionID()
}

protocol AuthServiceV4: AuthService {
    
    // MARK: - LOGIN
    func createRequestToken(completion: @escaping (Result<RequestTokenResponseV4, AuthError>) -> Void)
    func exchangeRequestToAccessToken(token: String, completion: @escaping (Result<AccessTokenResponseV4, AuthError>) -> Void)
    func getSessionIDUsingAccessToken(token: String, completion: @escaping (Result<NewSessionResponse, AuthError>) -> Void)
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void)
}
