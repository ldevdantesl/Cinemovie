//
//  LoginScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 31.01.2025
//

import UIKit

protocol LoginScreenRouterProtocol {
    func routeToMainView()
    func openOAuthURLWithToken(token: String)
}

final class LoginScreenRouter: LoginScreenRouterProtocol {
    weak var viewController: LoginScreenVC?
    weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator?) {
        self.appCoordinator = appCoordinator
    }
    
    func openOAuthURLWithToken(token: String) {
        let urlString = CONSTANTS.baseUniversalURLString + "/authenticate/\(token)?redirect_to=cinemovie://callback"
        guard let url = URL(string: urlString) else { return }
        AppOpener.openURL(url)
    }
    
    func routeToMainView() {
        appCoordinator?.showMainApp()
    }
}
