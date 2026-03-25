//
//  PersonDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

final class PersonDetailsScreenAssembler {
    static func assemble(creditID: String, networkService: NetworkServiceProtocol) -> PersonDetailsScreenVC {
        let interactor = PersonDetailsScreenInteractor(networkService: networkService)
        let router = PersonDetailsScreenRouter(networkService: networkService)
        let presenter = PersonDetailsScreenPresenter(creditID: creditID, interactor: interactor, router: router)
        let viewController = PersonDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
    
    static func assemble(personID: Int, networkService: NetworkServiceProtocol) -> PersonDetailsScreenVC {
        let interactor = PersonDetailsScreenInteractor(networkService: networkService)
        let router = PersonDetailsScreenRouter(networkService: networkService)
        let presenter = PersonDetailsScreenPresenter(personID: personID, interactor: interactor, router: router)
        let viewController = PersonDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
