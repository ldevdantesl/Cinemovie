//
//  SettingsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class SettingsScreenAssembler {
    static func assemble(diContainer: DIContainer, sessionDelegate: SessionDelegate?) -> SettingsScreenVC {
        let interactor = SettingsScreenInteractor(authService: diContainer.authService)
        let router = SettingsScreenRouter(sessionDelegate: sessionDelegate)
        let presenter = SettingsScreenPresenter(interactor: interactor, router: router)
        let viewController = SettingsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
