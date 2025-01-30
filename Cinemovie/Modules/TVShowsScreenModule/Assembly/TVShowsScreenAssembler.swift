//
//  TVShowsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class TVShowsScreenAssembler {
    static func assemble() -> TVShowsScreenVC {
        let interactor = TVShowsScreenInteractor()
        let router = TVShowsScreenRouter()
        let presenter = TVShowsScreenPresenter(interactor: interactor, router: router)
        let viewController = TVShowsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
