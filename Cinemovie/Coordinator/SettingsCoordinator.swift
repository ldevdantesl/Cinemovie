//
//  SettingsCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController

    weak var authService: AuthService?
    weak var appCoordinator: AppCoordinator?
    
    init(authService: AuthService?, appCoordinator: AppCoordinator?) {
        self.navigationController = UINavigationController()
        self.authService = authService
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let settingsModule = SettingsScreenAssembler.assemble(authService: authService, appCoordinator: appCoordinator)
        settingsModule.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 2
        )
        
        navigationController.viewControllers = [settingsModule]
    }
}
