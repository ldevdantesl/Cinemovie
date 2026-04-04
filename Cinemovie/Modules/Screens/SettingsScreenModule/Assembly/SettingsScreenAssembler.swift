//
//  SettingsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class SettingsScreenAssembler {
    static func assemble(diContainer: DIContainer, sessionDelegate: SessionDelegate?) -> SettingsScreenVC {
        let interactor = SettingsScreenInteractor(
            authService: diContainer.authService,
            networkService: diContainer.networkService,
            authContext: diContainer.authContext
        )
        let router = SettingsScreenRouter(sessionDelegate: sessionDelegate)
        let presenter = SettingsScreenPresenter(interactor: interactor, router: router, userService: diContainer.userService)
        let viewController = SettingsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
