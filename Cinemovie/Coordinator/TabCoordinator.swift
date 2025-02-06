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

    weak var authService: AuthService?
    weak var tmdbService: TMDBService?
    weak var appCoordinator: AppCoordinator?

    init(
        authService: AuthService?,
        tmdbService: TMDBService?,
        appCoordinator: AppCoordinator?
    ) {
        self.tabBarController = UITabBarController()
        self.authService = authService
        self.tmdbService = tmdbService
        self.appCoordinator = appCoordinator
    }

    func start() {
        let homeCoordinator = HomeCoordinator(tmdbService: tmdbService)
        let searchCoordinator = SearchCoordinator()
        let settingsCoordinator = SettingsCoordinator(
            authService: authService,
            appCoordinator: appCoordinator
        )

        homeCoordinator.start()
        searchCoordinator.start()
        settingsCoordinator.start()

        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            searchCoordinator.navigationController,
            settingsCoordinator.navigationController,
        ]
    }
}
