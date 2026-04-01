//
//  WatchlistScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

final class MyListsScreenAssembler {
    static func assemble(diContainer: DIContainer, sessionDelegate: SessionDelegate?) -> MyListsScreenVC {
        let interactor = MyListsScreenInteractor(networkService: diContainer.networkService)
        let router = MyListsScreenRouter(diContainer: diContainer, sessionDelegate: sessionDelegate)
        let presenter = MyListsScreenPresenter(authContext: diContainer.authContext, interactor: interactor, router: router)
        let viewController = MyListsScreenVC()
        presenter.view = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
