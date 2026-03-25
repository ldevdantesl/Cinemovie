//
//  TVSeriesDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

final class TVSeriesDetailsScreenAssembler {
    static func assemble(seriesID: Int, networkService: NetworkServiceProtocol) -> TVSeriesDetailsScreenVC {
        let interactor = TVSeriesDetailsScreenInteractor(networkService: networkService)
        let router = TVSeriesDetailsScreenRouter(networkService: networkService)
        let presenter = TVSeriesDetailsScreenPresenter(seriesID: seriesID, interactor: interactor, router: router)
        let viewController = TVSeriesDetailsScreenVC()
        presenter.view = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
