//
//  TabCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class TabCoordinator: CoordinatorProtocol {
    var tabBarController: UITabBarController

    private let authContext: AuthContextProtocol
    private let networkService: NetworkServiceProtocol
    weak var appCoordinator: AppCoordinator?

    init(
        authContext: AuthContextProtocol,
        networkService: NetworkServiceProtocol,
        appCoordinator: AppCoordinator?
    ) {
        self.tabBarController = UITabBarController()
        self.authContext = authContext
        self.networkService = networkService
        self.appCoordinator = appCoordinator
    }

    func start() {
        let homeCoordinator = DiscoverCoordinator(networkService: networkService)
        let watchlistCoordinator = MyListsCoordinator(networkService: networkService)
        let settingsCoordinator = SettingsCoordinator(authContext: authContext, appCoordinator: appCoordinator)

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
