//
//  AddToListModalAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 15.05.2025
//

import UIKit

final class AddToListModalAssembler {
    static func assemble(itemID: Int, mediaType: MediaTypes, tmdbService: TMDBService) -> AddToListModalVC {
        let interactor = AddToListModalInteractor(tmdbService: tmdbService)
        let router = AddToListModalRouter()
        let presenter = AddToListModalPresenter(itemID: itemID, mediaType: mediaType, interactor: interactor, router: router)
        let viewController = AddToListModalVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
