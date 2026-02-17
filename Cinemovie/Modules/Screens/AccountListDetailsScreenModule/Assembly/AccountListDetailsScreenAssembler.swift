//
//  WatchlistDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

final class AccountListDetailsScreenAssembler {
    static func assemble(listType: AccountListTypes, tmdbService: TMDBService) -> AccountListDetailsScreenVC {
        let interactor = AccountListDetailsScreenInteractor(tmdbService: tmdbService)
        let router = AccountListDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = AccountListDetailsScreenPresenter(listType: listType, interactor: interactor, router: router)
        let viewController = AccountListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
