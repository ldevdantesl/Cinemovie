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
    
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.navigationController = UINavigationController()
        self.tmdbService = tmdbService
    }
    
    func start() {
        let homeModule = HomeScreenAssembler.assemble(tmdbService: tmdbService)
        homeModule.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "mail.stack"),
            tag: 0
        )
        navigationController.viewControllers = [homeModule]
    }
}
