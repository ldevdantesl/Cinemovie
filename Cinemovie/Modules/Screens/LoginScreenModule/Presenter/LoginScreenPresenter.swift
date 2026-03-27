//
//  LoginScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import Foundation

protocol LoginScreenPresenterProtocol: AnyObject {
    func didPressLoginAsGuest()
    func didPressLoginWithTMDB()
    func didFinishLogin()
    func openOAuthURLWithToken(token: String)
    func handleOAuthCallback(url: URL)
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
    func didPressLoginWithTMDB() {
        interactor.loginWithTMDB()
    }
    
    func didPressLoginAsGuest() {
        interactor.loginAsGuest()
    }

    func didFinishLogin() {
        self.router.routeToMainView()
    }
    
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
                interactor.createSession(requestToken: token)
            } else {
                view?.didReceiveError(errorString: "Access was denied. Please try again.")
            }
        } else {
            view?.didReceiveError(errorString: "Could not handle OAuth callback")
        }
    }

    func didRecieveError(_ error: any Error) {
        switch error {
        case let error as APIError: self.view?.didReceiveError(errorString: error.localizedDescription)
        default: self.view?.didReceiveError(errorString: "Something went wrong, please try again")
        }
    }
}
