//
//  LoginScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

final class LoginScreenAssembler {
    static func assemble(
        diContainer: DIContainer,
        sessionDelegate: SessionDelegate?
    ) -> LoginScreenVC {
        let interactor = LoginScreenInteractor(authService: diContainer.authService)
        let router = LoginScreenRouter(sessionDelegate: sessionDelegate)
        let presenter = LoginScreenPresenter(interactor: interactor, router: router)
        let viewController = LoginScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
