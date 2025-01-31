//
//  TabCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class TabCoordinator: Coordinator {
    var tabBarController: UITabBarController
    
    init() {
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator()
        let searchCoordinator = SearchCoordinator()
        let settingsCoordinator = SettingsCoordinator()
        
        homeCoordinator.start()
        searchCoordinator.start()
        settingsCoordinator.start()
        
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            searchCoordinator.navigationController,
            settingsCoordinator.navigationController
        ]
    }
}
