//
//  HomeScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class DiscoverScreenAssembler {
    static func assemble(diContainer: DIContainer) -> DiscoverScreenVC {
        let interactor = DiscoverScreenInteractor(networkService: diContainer.networkService)
        let router = DiscoverScreenRouter(diContainer: diContainer)
        let presenter = DiscoverScreenPresenter(interactor: interactor, router: router)
        let viewController = DiscoverScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
