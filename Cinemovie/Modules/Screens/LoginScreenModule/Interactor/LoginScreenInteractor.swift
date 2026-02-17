//
//  LoginScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

protocol LoginScreenInteractorProtocol: AnyObject {
    // MARK: - LOGIN
    func loginAsGuest()
    func loginWithTMDB()
    
    // MARK: - AUTHENTICATION
    func exchangeRequestTokenForSession(_ token: String)
    func getSessionIDUsingAccessToken(accessToken: String)
    func exchangeRequestTokenForAccessToken()
    
    // MARK: - OTHER
    func storeAccountID()
}

final class LoginScreenInteractor: LoginScreenInteractorProtocol {
    weak var presenter: LoginScreenPresenterProtocol?
    private let authService: AuthService
    
    private var requestToken: String?
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - LOGIN
    func loginAsGuest() {
        authService.loginAsGuest { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presenter?.didFinishLogingAsGuest()
            case .failure(let error):
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func loginWithTMDB() {
        if let authServiceV3 = authService as? AuthServiceV3 {
            authServiceV3.createRequestToken { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.requestToken = token
                    self.presenter?.openOAuthURLWithToken(token: token)
                case .failure(let error): self.presenter?.didRecieveError(error)
                }
            }
        } else if let authServiceV4 = authService as? AuthServiceV4 {
            authServiceV4.createRequestToken { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.requestToken = success.requestToken
                    self.presenter?.openOAuthURLWithTokenV4(requestToken: success.requestToken)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        }
    }
    
    // MARK: - AUTHENTICATION
    func exchangeRequestTokenForSession(_ token: String) {
        guard let authServiceV3 = authService as? AuthServiceV3 else { return }
        authServiceV3.exchangeRequestToSession(token: token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success: self.presenter?.didLogInWithOAuthUsingV3()
            case .failure(let error): self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func exchangeRequestTokenForAccessToken() {
        guard let authServiceV4 = authService as? AuthServiceV4, let requestToken = requestToken else { return }
        authServiceV4.exchangeRequestToAccessToken(token: requestToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveAccessToken(accessToken: success.accessToken)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getSessionIDUsingAccessToken(accessToken: String) {
        guard let authServiceV4 = authService as? AuthServiceV4 else { return }
        authServiceV4.getSessionIDUsingAccessToken(token: accessToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didLogInWithOAuthUsingV4()
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - OTHER
    func storeAccountID() {
        guard let authServiceV3 = authService as? AuthServiceV3 else { return }
        authServiceV3.storeAccountIDIntoAccountStore { [weak self] in
            guard let self = self else { return }
            $0 ? self.presenter?.didStoreAccountID() : ()
            print("Account ID \($0 ? "successfully" : "has not been") stored")
        }
    }
}
