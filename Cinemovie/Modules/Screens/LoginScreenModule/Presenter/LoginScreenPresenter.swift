//
//  LoginScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import Foundation
import UIKit

protocol LoginScreenPresenterProtocol: AnyObject {
    // MARK: - STARTING
    func didPressLoginAsGuest()
    func didPressLoginWithTMDB()
    
    // MARK: - FINISHING
    func didFinishLogingAsGuest()
    func didFinishLogingAsGuest(withError error: AuthError)
    func didLoggedInWithOAuth()
    func didLoggedInWithOAuth(withError error: Error)
    
    // MARK: - OTHER
    func openOAuthURLWithToken(token: String)
    func cantOpenURLForToken(withError error: AuthError)
    func handleOAuthCallback(url: URL)
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
    // MARK: - STARTING
    func didPressLoginWithTMDB() {
        interactor.loginWithTMDB()
    }
    
    func didPressLoginAsGuest() {
        interactor.loginAsGuest()
    }
    
    // MARK: - OTHER
    func cantOpenURLForToken(withError error: AuthError) {
        view?.didReceiveError(error: error)
    }
    
    func openOAuthURLWithToken(token: String) {
        DispatchQueue.main.async { [weak self] in
            let urlString = CONSTANTS.baseUniversalURLString + "/authenticate/\(token)?redirect_to=cinemovie://callback"
            guard let url = URL(string: urlString) else { return }
            self?.view?.openURL(url)
        }
    }
    
    func handleOAuthCallback(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let token = components.queryItems?.first(where: { $0.name == "request_token" })?.value,
              let approved = components.queryItems?.first(where: { $0.name == "approved" })?.value else {
            view?.didReceiveError(errorString:" Invalid OAuth response ")
            return
        }
        
        if approved == "true" {
            interactor.exchangeRequestTokenForSession(token)
        } else {
            view?.didReceiveError(errorString: "Access was denied. Please try again.")
        }
    }
    
    // MARK: - FINISHING
    func didFinishLogingAsGuest() {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToMainView()
        }
    }
    
    func didFinishLogingAsGuest(withError error: AuthError) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didReceiveError(error: error)
        }
    }
    
    func didLoggedInWithOAuth() {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToMainView()
        }
    }
    
    func didLoggedInWithOAuth(withError error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didReceiveError(errorString: "Something went wrong please try again later.\(error.localizedDescription)")
        }
    }
}
