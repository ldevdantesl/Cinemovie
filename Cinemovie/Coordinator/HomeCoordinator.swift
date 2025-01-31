//
//  HomeCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let homeModule = HomeScreenAssembler.assemble()
        homeModule.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "mail.stack"),
            tag: 0
        )
        navigationController.viewControllers = [homeModule]
    }
}
