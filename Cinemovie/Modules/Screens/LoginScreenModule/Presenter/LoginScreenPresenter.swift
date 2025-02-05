//
//  LoginScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import Foundation

protocol LoginScreenPresenterProtocol: AnyObject {
    func didPressLoginAsGuest()
    func didFinishLogingAsGuest()
    func didFinishLogingAsGuest(withError error: AuthError)
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
    func didPressLoginAsGuest() {
        interactor.loginAsGuest()
    }
    
    func didFinishLogingAsGuest() {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToMainView()
        }
    }
    
    func didFinishLogingAsGuest(withError error: AuthError) {
        view?.didReceiveError(error: error)
    }
}
