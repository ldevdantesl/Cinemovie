//
//  HomeScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class DiscoverScreenAssembler {
    static func assemble(tmdbService: TMDBService) -> DiscoverScreenVC {
        let interactor = DiscoverScreenInteractor(tmdbService: tmdbService)
        let router = DiscoverScreenRouter(tmdbService: tmdbService)
        let presenter = DiscoverScreenPresenter(interactor: interactor, router: router)
        let viewController = DiscoverScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
