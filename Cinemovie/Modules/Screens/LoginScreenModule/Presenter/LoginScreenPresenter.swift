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
    
    func didRecieveError(_ error: any Error) {
        self.view?.didReceiveError(errorString: error.localizedDescription)
    }
}
