//
//  TVSeriesDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

final class TVSeriesDetailsScreenAssembler {
    static func assemble(seriesID: Int, tmdbService: TMDBService?) -> TVSeriesDetailsScreenVC {
        let interactor = TVSeriesDetailsScreenInteractor(tmdbService: tmdbService)
        let router = TVSeriesDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = TVSeriesDetailsScreenPresenter(seriesID: seriesID, interactor: interactor, router: router)
        let viewController = TVSeriesDetailsScreenVC()
        presenter.view = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
