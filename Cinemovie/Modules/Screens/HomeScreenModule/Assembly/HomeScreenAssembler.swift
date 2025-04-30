//
//  HomeScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class HomeScreenAssembler {
    static func assemble(tmdbService: TMDBService) -> HomeScreenVC {
        let interactor = HomeScreenInteractor(tmdbService: tmdbService)
        let router = HomeScreenRouter(tmdbService: tmdbService)
        let presenter = HomeScreenPresenter(interactor: interactor, router: router)
        let viewController = HomeScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
