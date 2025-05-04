//
//  WatchlistDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

final class WatchlistDetailsScreenAssembler {
    static func assemble(listType: UserListTypes, tmdbService: TMDBService) -> WatchlistDetailsScreenVC {
        let interactor = WatchlistDetailsScreenInteractor(tmdbService: tmdbService)
        let router = WatchlistDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = WatchlistDetailsScreenPresenter(listType: listType, interactor: interactor, router: router)
        let viewController = WatchlistDetailsScreenVC(listType: listType)
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
