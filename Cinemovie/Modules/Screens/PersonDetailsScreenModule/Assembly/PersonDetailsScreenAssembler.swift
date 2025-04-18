//
//  PersonDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

final class PersonDetailsScreenAssembler {
    static func assemble(creditID: String, tmdbService: TMDBService?) -> PersonDetailsScreenVC {
        let interactor = PersonDetailsScreenInteractor(tmdbService: tmdbService)
        let router = PersonDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = PersonDetailsScreenPresenter(creditID: creditID, interactor: interactor, router: router)
        let viewController = PersonDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
    
    static func assemble(personID: Int, tmdbService: TMDBService?) -> PersonDetailsScreenVC {
        let interactor = PersonDetailsScreenInteractor(tmdbService: tmdbService)
        let router = PersonDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = PersonDetailsScreenPresenter(personID: personID, interactor: interactor, router: router)
        let viewController = PersonDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
