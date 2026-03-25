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

    private let networkService: NetworkServiceProtocol
    weak var appCoordinator: AppCoordinator?
    
    init(networkService: NetworkServiceProtocol, appCoordinator: AppCoordinator?) {
        self.navigationController = UINavigationController()
        self.networkService = networkService
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let settingsModule = SettingsScreenAssembler.assemble(networkService: networkService, appCoordinator: appCoordinator)
        settingsModule.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 2
        )
        
        navigationController.viewControllers = [settingsModule]
    }
}
