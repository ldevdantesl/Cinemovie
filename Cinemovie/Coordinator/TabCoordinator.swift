//
//  TabCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class TabCoordinator {
    lazy var tabBarController: UITabBarController = UITabBarController()
    
    private weak var sessionDelegate: SessionDelegate?
    private let diContainer: DIContainer

    init(diContainer: DIContainer, sessionDelegate: SessionDelegate?) {
        self.diContainer = diContainer
        self.sessionDelegate = sessionDelegate
    }

    func start() {
        let homeCoordinator = DiscoverCoordinator(diContainer: diContainer)
        let watchlistCoordinator = MyListsCoordinator(diContainer: diContainer, sessionDelegate: sessionDelegate)
        let settingsCoordinator = SettingsCoordinator(diContainer: diContainer, sessionDelegate: sessionDelegate)

        homeCoordinator.start()
        watchlistCoordinator.start()
        settingsCoordinator.start()

        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            watchlistCoordinator.navigationController,
            settingsCoordinator.navigationController,
        ]
        tabBarController.tabBar.backgroundColor = CMColor.cmBackground
    }
}
