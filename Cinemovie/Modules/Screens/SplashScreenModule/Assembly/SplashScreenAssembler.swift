//
//  SplashScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class SplashScreenAssembler {
    static func assemble() -> SplashScreenVC {
        let interactor = SplashScreenInteractor()
        let router = SplashScreenRouter()
        let presenter = SplashScreenPresenter(interactor: interactor, router: router)
        let viewController = SplashScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
