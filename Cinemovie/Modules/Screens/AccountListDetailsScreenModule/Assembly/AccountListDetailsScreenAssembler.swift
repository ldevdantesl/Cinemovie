//
//  WatchlistDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

final class AccountListDetailsScreenAssembler {
    static func assemble(listType: AccountListTypes, networkService: NetworkServiceProtocol) -> AccountListDetailsScreenVC {
        let interactor = AccountListDetailsScreenInteractor(networkService: networkService)
        let router = AccountListDetailsScreenRouter(networkService: networkService)
        let presenter = AccountListDetailsScreenPresenter(listType: listType, interactor: interactor, router: router)
        let viewController = AccountListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
