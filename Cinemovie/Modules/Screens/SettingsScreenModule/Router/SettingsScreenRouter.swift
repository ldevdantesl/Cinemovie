//
//  SettingsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenRouterProtocol {
    func navigateBackToLogin()
}

final class SettingsScreenRouter: SettingsScreenRouterProtocol {
    weak var viewController: SettingsScreenVC?
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator?) {
        self.appCoordinator = appCoordinator
    }
    
    func navigateBackToLogin() {
        appCoordinator?.showLoginPage()
    }
}
