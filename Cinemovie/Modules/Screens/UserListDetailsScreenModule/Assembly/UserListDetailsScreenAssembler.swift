//
//  UserListDetailsScreenAssembler.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit

final class UserListDetailsScreenAssembler {
    static func assemble(userList: UserList, diContainer: DIContainer) -> UserListDetailsScreenVC {
        let interactor = UserListDetailsScreenInteractor(networkService: diContainer.networkService)
        let router = UserListDetailsScreenRouter(diContainer: diContainer)
        let presenter = UserListDetailsScreenPresenter(userList: userList, interactor: interactor, router: router)
        let viewController = UserListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
    
    static func assemble(userListDetails: UserListDetails, diContainer: DIContainer) -> UserListDetailsScreenVC {
        let interactor = UserListDetailsScreenInteractor(networkService: diContainer.networkService)
        let router = UserListDetailsScreenRouter(diContainer: diContainer)
        let presenter = UserListDetailsScreenPresenter(userListDetails: userListDetails, interactor: interactor, router: router)
        let viewController = UserListDetailsScreenVC()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
