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
    func didFinishLogingAsGuest()
    func didLogInWithOAuthUsingV3()
    func didLogInWithOAuthUsingV4()
    func didStoreAccountID()
    func didReceiveAccessToken(accessToken: String)
    
    // MARK: - OTHER
    func openOAuthURLWithToken(token: String)
    func openOAuthURLWithTokenV4(requestToken: String)
    func handleOAuthCallback(url: URL)
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
}

final class LoginScreenPresenter {
    weak var view: LoginScreenViewProtocol?
    var router: LoginScreenRouterProtocol
    var interactor: LoginScreenInteractorProtocol

    init(interactor: LoginScreenInteractorProtocol, router: LoginScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
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
    func didFinishLogingAsGuest() {
        DispatchQueue.main.async {
            self.router.routeToMainView()
        }
    }
    
    func didLogInWithOAuthUsingV3() {
        self.interactor.storeAccountID()
    }
    
    func didLogInWithOAuthUsingV4() {
        DispatchQueue.main.async {
            self.router.routeToMainView()
        }
    }
    
    func didStoreAccountID() {
        DispatchQueue.main.async {
            self.router.routeToMainView()
        }
    }
    
    func didReceiveAccessToken(accessToken: String) {
        self.interactor.getSessionIDUsingAccessToken(accessToken: accessToken)
    }
    
    // MARK: - OTHER
    func openOAuthURLWithToken(token: String) {
        DispatchQueue.main.async {
            self.router.openOAuthURLWithToken(token: token)
        }
    }
    
    func openOAuthURLWithTokenV4(requestToken: String) {
        DispatchQueue.main.async {
            self.router.openOAuthURLWithTokenV4(token: requestToken)
        }
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
            interactor.exchangeRequestTokenForAccessToken()
        }
    }

    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        switch error {
        case let error as AuthError: self.view?.didReceiveError(errorString: error.localizedDescription)
        default: self.view?.didReceiveError(errorString: "Something went wrong please try")
        }
    }
}
