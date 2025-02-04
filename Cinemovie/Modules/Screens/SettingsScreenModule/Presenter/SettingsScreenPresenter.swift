//
//  SettingsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenPresenterProtocol: AnyObject {
    func didPressLogoutButton()
}

final class SettingsScreenPresenter {
    weak var view: SettingsScreenViewProtocol?
    var router: SettingsScreenRouterProtocol
    var interactor: SettingsScreenInteractorProtocol

    init(interactor: SettingsScreenInteractorProtocol, router: SettingsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension SettingsScreenPresenter: SettingsScreenPresenterProtocol {
    func didPressLogoutButton() {
        interactor.logout()
        router.navigateBackToLogin()
    }
}
