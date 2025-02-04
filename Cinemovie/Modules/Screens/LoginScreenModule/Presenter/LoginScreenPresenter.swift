//
//  LoginScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

protocol LoginScreenPresenterProtocol: AnyObject {
    func didPressLoginAsGuest()
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
        router.routeToMainView()
    }
}
