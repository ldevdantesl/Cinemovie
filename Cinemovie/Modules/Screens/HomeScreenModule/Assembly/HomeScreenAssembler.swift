//
//  HomeScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class HomeScreenAssembler {
    static func assemble() -> HomeScreenVC {
        let interactor = HomeScreenInteractor()
        let router = HomeScreenRouter()
        let presenter = HomeScreenPresenter(interactor: interactor, router: router)
        let viewController = HomeScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
