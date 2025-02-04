//
//  LoginScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

protocol LoginScreenRouterProtocol {
    func routeToMainView()
}

final class LoginScreenRouter: LoginScreenRouterProtocol {
    weak var viewController: LoginScreenVC?
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator?) {
        self.appCoordinator = appCoordinator
    }
    
    func routeToMainView() {
        appCoordinator?.showMainApp()
    }
}
