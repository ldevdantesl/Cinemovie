//
//  SettingsCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class SettingsCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController

    private let authContext: AuthContextProtocol
    weak var appCoordinator: AppCoordinator?
    
    init(authContext: AuthContextProtocol, appCoordinator: AppCoordinator?) {
        self.navigationController = UINavigationController()
        self.authContext = authContext
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
