//
//  MovieDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

final class MovieDetailsScreenAssembler {
    static func assemble(movie: Movie, tmdbService: TMDBService) -> MovieDetailsScreenVC {
        RecentMediaHelper.addRecentMedia(media: movie)
        let interactor = MovieDetailsScreenInteractor(tmdbService: tmdbService)
        let router = MovieDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = MovieDetailsScreenPresenter(movieID: movie.id, interactor: interactor, router: router)
        let viewController = MovieDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
