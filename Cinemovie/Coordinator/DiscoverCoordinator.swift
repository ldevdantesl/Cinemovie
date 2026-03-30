//
//  HomeCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class DiscoverCoordinator {
    lazy var navigationController: UINavigationController = UINavigationController()
    
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func start() {
        let homeModule = DiscoverScreenAssembler.assemble(diContainer: diContainer)
        homeModule.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "binoculars.fill"),
            tag: 0
        )
        self.navigationController.viewControllers = [homeModule]
    }
}
