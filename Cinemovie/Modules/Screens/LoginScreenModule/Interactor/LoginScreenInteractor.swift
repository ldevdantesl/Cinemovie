//
//  LoginScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

protocol LoginScreenInteractorProtocol: AnyObject {
    func loginAsGuest()
    func loginWithTMDB()
    func storeAccountID()
    func exchangeRequestTokenForSession(_ token: String)
}

final class LoginScreenInteractor: LoginScreenInteractorProtocol {
    weak var presenter: LoginScreenPresenterProtocol?
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
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
        authService.createRequestToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token): self.presenter?.openOAuthURLWithToken(token: token)
            case .failure(let error): self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func storeAccountID() {
        authService.storeAccountIDIntoAccountStore { [weak self] in
            guard let self = self else { return }
            $0 ? self.presenter?.didStoreAccountID() : ()
            print("Account ID \($0 ? "successfully" : "has not been") stored")
        }
    }
    
    func exchangeRequestTokenForSession(_ token: String) {
        authService.loginWithOAuth(token: token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success: self.presenter?.didLogInWithOAuth()
            case .failure(let error): self.presenter?.didRecieveError(error)
            }
        }
    }
}
