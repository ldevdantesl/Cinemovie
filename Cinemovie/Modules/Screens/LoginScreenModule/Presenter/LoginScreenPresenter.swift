//
//  LoginScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import Foundation
import UIKit

protocol LoginScreenPresenterProtocol: AnyObject {
    // MARK: - USER INITIATED
    func didPressLoginAsGuest()
    func didPressLoginWithTMDB()
    
    // MARK: - PROGRAMMATIC
    func didFinishLoging(sessionID: String)
    func didLogInWithOAuth(sessionID: String)
    func didStoreAccountID()
    func didReceiveAccessToken(accessToken: String)
    
    // MARK: - OTHER
    func openOAuthURLWithToken(token: String)
    func handleOAuthCallback(url: URL)
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
}

final class LoginScreenPresenter {
    // MARK: - VIPER
    weak var view: LoginScreenViewProtocol?
    var router: LoginScreenRouterProtocol
    var interactor: LoginScreenInteractorProtocol
    
    // MARK: - INJECTED
    private let accountStore: AccountStoreProtocol

    init(interactor: LoginScreenInteractorProtocol, router: LoginScreenRouterProtocol, accountStore: AccountStoreProtocol) {
        self.interactor = interactor
        self.router = router
        self.accountStore = accountStore
    }
}

extension LoginScreenPresenter: LoginScreenPresenterProtocol {
    // MARK: - USER INITIATED
    func didPressLoginWithTMDB() {
        interactor.loginWithTMDB()
    }
    
    func didPressLoginAsGuest() {
        interactor.loginAsGuest()
    }

    // MARK: - PROGRAMMATIC
    func didFinishLoging(sessionID: String) {
        self.accountStore.sessionID = sessionID
        self.router.routeToMainView()
    }
    
    func didLogInWithOAuth(sessionID: String) {
        self.accountStore.sessionID = sessionID
    }
    
    func didStoreAccountID() {
        DispatchQueue.main.async {
            self.router.routeToMainView()
        }
    }
    
    func didReceiveAccessToken(accessToken: String) {
        self.accountStore.accessToken = accessToken
        self.interactor.getSessionIDUsingAccessToken(accessToken: accessToken)
    }
    
    // MARK: - OTHER
    func openOAuthURLWithToken(token: String) {
        self.router.openOAuthURLWithToken(token: token)
    }
    
    func handleOAuthCallback(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            view?.didReceiveError(errorString: "Invalid OAuth response")
            return
        }

        if let token = components.queryItems?.first(where: { $0.name == "request_token" })?.value,
           let approved = components.queryItems?.first(where: { $0.name == "approved" })?.value {
            if approved == "true" {
                interactor.exchangeRequestTokenForSession(token)
            } else {
                view?.didReceiveError(errorString: "Access was denied. Please try again.")
            }
        } else {
            print("Cant handle Oauth Token")
        }
    }

    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        switch error {
        case let error as APIError: self.view?.didReceiveError(errorString: error.localizedDescription)
        default: self.view?.didReceiveError(errorString: "Something went wrong please try")
        }
    }
}
