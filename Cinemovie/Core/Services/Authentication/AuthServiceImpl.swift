//
//  AuthServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

final class AuthServiceImpl: AuthService {
    private let sessionIDKey = "sessionIDKey"
    private let guestSessionIDKey = "guestSessionIDKey"
    
    weak var networkService: NetworkService?
    
    init(networkService: NetworkService? = nil) {
        self.networkService = networkService
    }
    
    var isLoggedIn: Bool {
        return sessionID != nil || guestSessionID != nil
    }
    
    var sessionID: String? {
        return UserDefaults.standard.string(forKey: sessionIDKey)
    }
    
    var guestSessionID: String? {
        return UserDefaults.standard.string(forKey: guestSessionIDKey)
    }
    
    func loginWithOAuth(token: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        let endpoint = NewSessionEndpoint(body: ["request_token" : token])
        networkService?.request(endpoint) { [weak self] (result: Result<NewSessionResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                UserDefaults.standard.set(response.sessionId, forKey: self.sessionIDKey)
                completion(.success(response.sessionId))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func createRequestToken(completion: @escaping (Result<String, AuthError>) -> Void) {
        let endpoint = CreateRequestTokenEndpoint()
        networkService?.request(endpoint) { (result: Result<RequestTokenResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success((response.requestToken)))
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
                UserDefaults.standard.removeObject(forKey: self.guestSessionIDKey)
                UserDefaults.standard.set(response.guestSessionId, forKey: self.guestSessionIDKey)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: self.sessionIDKey)
        UserDefaults.standard.removeObject(forKey: self.guestSessionIDKey)
        guard let sessionID = sessionID else { return }
        let endpoint = DeleteSessionEndpoint(sessionId: sessionID)
        networkService?.request(endpoint) { (result: Result<DeleteSessionResponse, NetworkError>) in }
    }
    
    func validateToken() -> Bool {
        guard let session = sessionID else { return false }
        return !session.isEmpty
    }
}
