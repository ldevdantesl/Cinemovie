//
//  AuthServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 3.02.2025.
//

import Foundation

final class AuthServiceImpl: AuthService {
    private let oAuthTokenKey = "oAuthTokenKey"
    
    weak var networkService: NetworkService?
    
    init(networkService: NetworkService? = nil) {
        self.networkService = networkService
    }
    
    var isLoggedIn: Bool {
        return oAuthToken != nil
    }
    
    var oAuthToken: String? {
        return UserDefaults.standard.string(forKey: oAuthTokenKey)
    }
    
    func loginWithOAuth(token: String) {
        UserDefaults.standard.set(token, forKey: oAuthTokenKey)
    }
    
    func loginAsGuest(completion: @escaping (Result<Void, AuthError>) -> Void) {
        let endpoint = LoginAsGuestEndpoint()
        networkService?.request(endpoint) { (result: Result<GuestSessionResponse, NetworkError>) in
            switch result {
            case .success(let response):
                UserDefaults.standard.removeObject(forKey: self.oAuthTokenKey)
                UserDefaults.standard.set(response.guest_session_id, forKey: self.oAuthTokenKey)
                print("Got the response: \(response.guest_session_id)")
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
