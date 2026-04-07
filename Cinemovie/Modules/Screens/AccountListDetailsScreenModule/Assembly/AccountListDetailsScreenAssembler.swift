//
//  WatchlistDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

final class AccountListDetailsScreenAssembler {
    static func assemble(listType: AccountListTypes, diContainer: DIContainer) -> AccountListDetailsScreenVC {
        let interactor = AccountListDetailsScreenInteractor(networkService: diContainer.networkService)
        let router = AccountListDetailsScreenRouter(diContainer: diContainer)
        let presenter = AccountListDetailsScreenPresenter(listType: listType, interactor: interactor, router: router)
        let viewController = AccountListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
