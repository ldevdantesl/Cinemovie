//
//  ActorDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 19.03.2025
//

import UIKit

final class ActorDetailsScreenAssembler {
    static func assemble() -> ActorDetailsScreenVC {
        let interactor = ActorDetailsScreenInteractor()
        let router = ActorDetailsScreenRouter()
        let presenter = ActorDetailsScreenPresenter(interactor: interactor, router: router)
        let viewController = ActorDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
