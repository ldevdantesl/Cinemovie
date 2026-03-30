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
    
    private var pendingRequestToken: String?

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
        self.pendingRequestToken = token
        self.router.openOAuthURLWithTokenV4(token: token)
    }
    
    func handleOAuthCallback(url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let token = components?.queryItems?.first(where: { $0.name == "request_token" })?.value,
           let approved = components?.queryItems?.first(where: { $0.name == "approved" })?.value {
            if approved == "true" {
                interactor.createSessionV3(requestToken: token)
            } else {
                view?.didReceiveError(errorString: "Access was denied. Please try again.")
            }
        }
        else if let requestToken = pendingRequestToken {
            interactor.completeV4Login(requestToken: requestToken)
            pendingRequestToken = nil
        } else {
            view?.didReceiveError(errorString: "Could not handle OAuth callback")
        }
    }

    func didRecieveError(_ error: any Error) {
        self.view?.didReceiveError(errorString: error.localizedDescription)
    }
}
