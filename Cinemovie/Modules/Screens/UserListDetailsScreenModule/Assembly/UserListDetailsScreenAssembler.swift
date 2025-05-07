//
//  WatchlistDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

final class UserListDetailsScreenAssembler {
    static func assemble(listType: UserListTypes, tmdbService: TMDBService) -> UserListDetailsScreenVC {
        let interactor = UserListDetailsScreenInteractor(tmdbService: tmdbService)
        let router = UserListDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = UserListDetailsScreenPresenter(listType: listType, interactor: interactor, router: router)
        let viewController = UserListDetailsScreenVC(listType: listType)
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
