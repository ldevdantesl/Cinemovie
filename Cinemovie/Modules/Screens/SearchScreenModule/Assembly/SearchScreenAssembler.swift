//
//  SearchScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

final class SearchScreenAssembler {
    static func assemble(tmdbService: TMDBService) -> SearchScreenVC {
        let interactor = SearchScreenInteractor(tmdbService: tmdbService)
        let router = SearchScreenRouter()
        let presenter = SearchScreenPresenter(interactor: interactor, router: router)
        let viewController = SearchScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
