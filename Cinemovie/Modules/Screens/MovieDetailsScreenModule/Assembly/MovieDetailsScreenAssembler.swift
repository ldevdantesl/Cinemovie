//
//  MovieDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

final class MovieDetailsScreenAssembler {
    static func assemble(movieID: Int, diContainer: DIContainer) -> MovieDetailsScreenVC {
        let interactor = MovieDetailsScreenInteractor(networkService: diContainer.networkService)
        let router = MovieDetailsScreenRouter(diContainer: diContainer)
        let presenter = MovieDetailsScreenPresenter(movieID: movieID, authContext: diContainer.authContext, interactor: interactor, router: router)
        let viewController = MovieDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
