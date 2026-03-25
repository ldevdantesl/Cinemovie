//
//  SettingsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class SettingsScreenAssembler {
    static func assemble(networkService: NetworkServiceProtocol, appCoordinator: AppCoordinator?) -> SettingsScreenVC {
        let interactor = SettingsScreenInteractor(networkService: networkService)
        let router = SettingsScreenRouter(appCoordinator: appCoordinator)
        let presenter = SettingsScreenPresenter(interactor: interactor, router: router)
        let viewController = SettingsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
