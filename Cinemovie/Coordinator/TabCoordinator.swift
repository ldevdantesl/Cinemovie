//
//  TabCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class TabCoordinator: CoordinatorProtocol {
    lazy var tabBarController: UITabBarController = UITabBarController()

    private let authService: AuthServiceProtocol
    private let networkService: NetworkServiceProtocol
    weak var appCoordinator: AppCoordinator?

    init(
        authService: AuthServiceProtocol,
        networkService: NetworkServiceProtocol,
        appCoordinator: AppCoordinator?
    ) {
        self.authService = authService
        self.networkService = networkService
        self.appCoordinator = appCoordinator
    }

    func start() {
        let homeCoordinator = DiscoverCoordinator(networkService: networkService)
        let watchlistCoordinator = MyListsCoordinator(networkService: networkService)
        let settingsCoordinator = SettingsCoordinator(networkService: networkService, appCoordinator: appCoordinator)

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
