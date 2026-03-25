//
//  UserListDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit

final class UserListDetailsScreenAssembler {
    static func assemble(userList: UserList, networkService: NetworkServiceProtocol) -> UserListDetailsScreenVC {
        let interactor = UserListDetailsScreenInteractor(networkService: networkService)
        let router = UserListDetailsScreenRouter(networkService: networkService)
        let presenter = UserListDetailsScreenPresenter(userList: userList, interactor: interactor, router: router)
        let viewController = UserListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
    
    static func assemble(userListDetails: UserListDetails, networkService: NetworkServiceProtocol) -> UserListDetailsScreenVC {
        let interactor = UserListDetailsScreenInteractor(networkService: networkService)
        let router = UserListDetailsScreenRouter(networkService: networkService)
        let presenter = UserListDetailsScreenPresenter(userListDetails: userListDetails, interactor: interactor, router: router)
        let viewController = UserListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
