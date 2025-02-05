//
//  AuthServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

final class AuthServiceImpl: AuthService {
    private let oAuthTokenKey = "oAuthTokenKey"
    private let guestSessionIdKey = "guestSessionIdKey"
    
    weak var networkService: NetworkService?
    
    init(networkService: NetworkService? = nil) {
        self.networkService = networkService
    }
    
    var isLoggedIn: Bool {
        return oAuthToken != nil || guestSessionId != nil
    }
    
    var oAuthToken: String? {
        return UserDefaults.standard.string(forKey: oAuthTokenKey)
    }
    
    var guestSessionId: String? {
        return UserDefaults.standard.string(forKey: guestSessionIdKey)
    }
    
    func loginWithOAuth(token: String) { }
    
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void) {
        let endpoint = CreateRequestTokenEndpoint()
        networkService?.request(endpoint) { (result: Result<RequestTokenResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success((response.request_token)))
            case .failure(let error): completion(.failure(.networkError(error)))
            }
        }
    }
    
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void) {
        let endpoint = LoginAsGuestEndpoint()
        networkService?.request(endpoint) { [weak self] (result: Result<GuestSessionResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                UserDefaults.standard.removeObject(forKey: self.guestSessionIdKey)
                UserDefaults.standard.set(response.guest_session_id, forKey: self.guestSessionIdKey)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: oAuthTokenKey)
    }
    
    func validateToken() -> Bool {
        guard let token = oAuthToken else { return false }
        return !token.isEmpty
    }
}
