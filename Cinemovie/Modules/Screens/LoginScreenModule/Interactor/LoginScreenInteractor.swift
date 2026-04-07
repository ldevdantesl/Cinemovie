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
    func createSessionV3(requestToken: String)
    func completeV4Login(requestToken: String)
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
                print("✅ V4 request token: \(token)")
                await MainActor.run { self.presenter?.openOAuthURLWithToken(token: token) }
            } catch {
                print("❌ loginWithTMDB failed: \(error)")
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
    
    func createSessionV3(requestToken: String) {
        Task {
            do {
                try await authService.createSessionV3(requestToken: requestToken)
                await MainActor.run { self.presenter?.didFinishLogin() }
            } catch {
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
    
    func completeV4Login(requestToken: String) {
        Task {
            do {
                try await authService.exchangeForAccessToken(requestToken: requestToken)
                try await authService.convertAccessTokenToSession()
                await MainActor.run { self.presenter?.didFinishLogin() }
            } catch {
                await MainActor.run { self.presenter?.didRecieveError(error) }
            }
        }
    }
}
