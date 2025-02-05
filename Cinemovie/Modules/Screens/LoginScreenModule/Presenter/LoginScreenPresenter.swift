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
    
    // MARK: - OTHER
    func openOAuthURLWithToken(token: String)
    func cantOpenURLForToken(withError error: AuthError)
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
            let urlString = Constants.baseUniversalURLString + "/authenticate/\(token)"
            self?.view?.openURLInSheet(urlString)
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
}
