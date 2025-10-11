//
//  TVSeriesDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

final class TVSeriesDetailsScreenAssembler {
    static func assemble(series: TVSeries, tmdbService: TMDBService) -> TVSeriesDetailsScreenVC {
        RecentMediaHelper.addRecentMedia(media: series)
        let interactor = TVSeriesDetailsScreenInteractor(tmdbService: tmdbService)
        let router = TVSeriesDetailsScreenRouter(tmdbService: tmdbService)
        let presenter = TVSeriesDetailsScreenPresenter(seriesID: series.id, interactor: interactor, router: router)
        let viewController = TVSeriesDetailsScreenVC()
        presenter.view = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
