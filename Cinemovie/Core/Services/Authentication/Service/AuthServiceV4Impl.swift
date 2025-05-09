//
//  AuthServiceV4Impl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 8.05.2025.
//

import UIKit

final class AuthServiceV4Impl: AuthServiceV4 {
    private let accountStore: AccountStore
    private let networkService: NetworkService
    
    init(accountStore: AccountStore, networkService: NetworkService) {
        self.accountStore = accountStore
        self.networkService = networkService
    }
    
    var isLoggedIn: Bool {
        accountStore.isLoggedIn
    }
    
    func createRequestToken(completion: @escaping (Result<RequestTokenResponseV4, AuthError>) -> Void) {
        let endpoint = AuthEndpointsV4.createRequestTokenEndpoint()
        networkService.request(endpoint) { (result: Result<RequestTokenResponseV4, NetworkError>) in
            switch result {
            case .success(let success): completion(.success(success))
            case .failure: completion(.failure(.cantCreateRequestToken))
            }
        }
    }
    
    func exchangeRequestToAccessToken(token: String, completion: @escaping (Result<AccessTokenResponseV4, AuthError>) -> Void) {
        let endpoint = AuthEndpointsV4.requestAccessTokenEndpoint(requestToken: token)
        networkService.request(endpoint) { (result: Result<AccessTokenResponseV4, NetworkError> ) in
            switch result {
            case .success(let success):
                completion(.success(success))
                self.accountStore.accountID = success.accountId
                self.accountStore.accessToken = success.accessToken
            case .failure: completion(.failure(.cantExchangeRequestTokenToAccessToken))
            }
        }
    }
    
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void) {
        let endpoint = AuthEndpointsV3.loginAsGuestEndpoint()
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
    
    func getSessionIDUsingAccessToken(token: String, completion: @escaping (Result<NewSessionResponse, AuthError>) -> Void) {
        let endpoint = AuthEndpointsV4.getSessionIDUsingAccessTokenEndpoint(accessToken: token)
        networkService.request(endpoint) { [weak self] (result: Result<NewSessionResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.accountStore.sessionID = success.sessionId
                completion(.success(success))
            case .failure(let failure): completion(.failure(.networkError(failure)))
            }
        }
    }
    
    func logout() {
        guard let accessToken = accountStore.accessToken else { return }
        let endpoint = AuthEndpointsV4.logOutEndpoint(accessToken: accessToken)
        networkService.request(endpoint) { [weak self] (result: Result<DeleteAccessTokenResponseV4, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.accountStore.clear()
            case .failure:
                break;
            }
        }
    }
}
