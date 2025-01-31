//
//  SearchScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

final class SearchScreenAssembler {
    static func assemble() -> SearchScreenVC {
        let interactor = SearchScreenInteractor()
        let router = SearchScreenRouter()
        let presenter = SearchScreenPresenter(interactor: interactor, router: router)
        let viewController = SearchScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
