//
//  SettingsCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class SettingsCoordinator {
    lazy var navigationController: UINavigationController = UINavigationController()

    private let diContainer: DIContainer
    private weak var sessionDelegate: SessionDelegate?
    
    init(diContainer: DIContainer, sessionDelegate: SessionDelegate?) {
        self.diContainer = diContainer
        self.sessionDelegate = sessionDelegate
    }
    
    func start() {
        let settingsModule = SettingsScreenAssembler.assemble(diContainer: diContainer, sessionDelegate: sessionDelegate)
        settingsModule.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 2
        )
        
        navigationController.viewControllers = [settingsModule]
    }
}
