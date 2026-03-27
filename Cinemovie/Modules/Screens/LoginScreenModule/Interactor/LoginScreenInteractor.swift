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
    func createSession(requestToken: String)
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
                let token = try await authService.createRequestToken()
                await MainActor.run { self.presenter?.openOAuthURLWithToken(token: token) }
            } catch {
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
    
    func createSession(requestToken: String) {
        Task {
            do {
                try await authService.createSession(requestToken: requestToken)
                await MainActor.run { self.presenter?.didFinishLogin() }
            } catch {
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
}
