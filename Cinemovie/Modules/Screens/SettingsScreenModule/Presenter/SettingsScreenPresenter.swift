//
//  SettingsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol SettingsScreenPresenterProtocol: AnyObject {
    // MARK: - START
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
    // MARK: - STARTING
    func didPressLogoutButton() {
        interactor.logout()
        DispatchQueue.main.async { [weak self] in
            self?.router.navigateBackToLogin()
        }
    }
}
