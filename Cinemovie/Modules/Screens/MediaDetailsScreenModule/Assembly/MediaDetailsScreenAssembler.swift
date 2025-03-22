//
//  MovieDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

final class MediaDetailsScreenAssembler {
    static func assemble(movieID: Int, tmdbService: TMDBService?) -> MediaDetailsScreenVC {
        let interactor = MediaDetailsScreenInteractor(movieID: movieID, tmdbService: tmdbService)
        let router = MediaDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = MediaDetailsScreenPresenter(interactor: interactor, router: router)
        let viewController = MediaDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
