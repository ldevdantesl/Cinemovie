//
//  AuthServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

final class AuthServiceImpl: AuthService {
    private let networkService: NetworkService
    private let accountStore: AccountStore
    
    init(accountStore: AccountStore, networkService: NetworkService) {
        self.networkService = networkService
        self.accountStore = accountStore
    }
    
    var isLoggedIn: Bool {
        return accountStore.isLoggedIn
    }
    
    func loginWithOAuth(token: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let endpoint = AuthenticationEndpoints.newSessionEndpoint(requestToken: token)
        networkService.request(endpoint) { [weak self] (result: Result<NewSessionResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.accountStore.sessionID = response.sessionId
                completion(.success(response.sessionId))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void) {
        let endpoint = AuthenticationEndpoints.createRequestTokenEndpoint()
        networkService.request(endpoint) { (result: Result<RequestTokenResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success((response.requestToken)))
            case .failure(let error): completion(.failure(.networkError(error)))
            }
        }
    }
    
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void) {
        let endpoint = AuthenticationEndpoints.loginAsGuestEndpoint()
        networkService.request(endpoint) { [weak self] (result: Result<GuestSessionResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.accountStore.guestSessionID = response.guestSessionId
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func logout() {
        accountStore.sessionID = nil
        accountStore.guestSessionID = nil
    }
}
