//
//  LoginScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

final class LoginScreenAssembler {
    static func assemble(
        networkService: NetworkServiceProtocol,
        accountStore: AccountStoreProtocol,
        appCoordinator: AppCoordinator?
    ) -> LoginScreenVC {
        let interactor = LoginScreenInteractor(networkService: networkService)
        let router = LoginScreenRouter(appCoordinator: appCoordinator)
        let presenter = LoginScreenPresenter(interactor: interactor, router: router, accountStore: accountStore)
        let viewController = LoginScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
