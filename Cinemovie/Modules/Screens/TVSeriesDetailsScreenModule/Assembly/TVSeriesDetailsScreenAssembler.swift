//
//  TVSeriesDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

final class TVSeriesDetailsScreenAssembler {
    static func assemble(seriesID: Int, diContainer: DIContainer) -> TVSeriesDetailsScreenVC {
        let interactor = TVSeriesDetailsScreenInteractor(networkService: diContainer.networkService)
        let router = TVSeriesDetailsScreenRouter(diContainer: diContainer)
        let presenter = TVSeriesDetailsScreenPresenter(seriesID: seriesID, authContext: diContainer.authContext, interactor: interactor, router: router)
        let viewController = TVSeriesDetailsScreenVC()
        presenter.view = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
