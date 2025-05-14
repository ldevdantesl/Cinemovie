//
//  UserListDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit

final class UserListDetailsScreenAssembler {
    static func assemble(listID: Int, tmdbService: TMDBService) -> UserListDetailsScreenVC {
        let interactor = UserListDetailsScreenInteractor(tmdbService: tmdbService)
        let router = UserListDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = UserListDetailsScreenPresenter(listID: listID, interactor: interactor, router: router)
        let viewController = UserListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
