//
//  WatchlistScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

final class WatchlistScreenAssembler {
    static func assemble(tmdbService: TMDBService) -> WatchlistScreenVC {
        let interactor = WatchlistScreenInteractor(tmdbService: tmdbService)
        let router = WatchlistScreenRouter(tmdbService: tmdbService)
        let presenter = WatchlistScreenPresenter(interactor: interactor, router: router)
        let viewController = WatchlistScreenVC()
        presenter.view = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
