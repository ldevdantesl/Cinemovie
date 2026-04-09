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
}

final class LoginScreenInteractor: LoginScreenInteractorProtocol {
    weak var presenter: LoginScreenPresenterProtocol?
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func loginAsGuest() {
        Task {
            do {
                try await authService.loginAsGuest()
                await MainActor.run { self.presenter?.didFinishLogin() }
            } catch {
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
    
    func loginWithTMDB() {
        Task {
            do {
                let token = try await authService.createRequestTokenV4()
                
                try await authService.loginWithOAuth(requestToken: token)
                
                try await authService.exchangeForAccessToken(requestToken: token)
                try await authService.convertAccessTokenToSession()
                await MainActor.run { self.presenter?.didFinishLogin() }
            } catch {
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
}
