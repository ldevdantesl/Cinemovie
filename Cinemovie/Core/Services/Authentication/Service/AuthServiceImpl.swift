//
//  AuthServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

final class AuthServiceImpl: AuthService {
    // MARK: - PRIVATE PROPERTIES
    private let networkService: NetworkService
    private let accountStore: AccountStore
    
    // MARK: - PROPERTIES
    var isLoggedIn: Bool {
        return accountStore.isLoggedIn
    }
    
    // MARK: - LIFECYCLE
    init(accountStore: AccountStore, networkService: NetworkService) {
        self.networkService = networkService
        self.accountStore = accountStore
    }
    
    // MARK: - LOGIN
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
                self.accountStore.sessionID = response.guestSessionId
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func logout() {
        accountStore.sessionID = nil
    }
    
    // MARK: - OTHER
    func getSessionID() {
        print("Session: \(accountStore.sessionID ?? "none")")
    }
    
    func storeAccountIDIntoAccountStore(completion: @escaping (Bool) -> Void) {
        guard let sessionID = accountStore.sessionID, !accountStore.isGuest else { completion(false); return }
        let endpoint = AuthenticationEndpoints.getAccountDetailsEndpoint(sessionID: sessionID)
        networkService.request(endpoint) { [weak self] (result: Result<AccountDetails, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let details):
                self.accountStore.accountID = details.id
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func getAccountDetails(completion: @escaping (Result<AccountDetails, AuthError>) -> Void) {
        guard let sessionID = accountStore.sessionID, !accountStore.isGuest else { completion(.failure(.notValidSessionID)); return }
        let endpoint = AuthenticationEndpoints.getAccountDetailsEndpoint(sessionID: sessionID)
        networkService.request(endpoint) { (result: Result<AccountDetails, NetworkError>) in
            switch result {
            case .success(let details): completion(.success(details))
            case .failure(let error): completion(.failure(.networkError(error)))
            }
        }
    }
}
