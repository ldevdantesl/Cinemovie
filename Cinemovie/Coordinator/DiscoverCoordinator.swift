//
//  HomeCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class DiscoverCoordinator: Coordinator {
    let navigationController: UINavigationController = UINavigationController()
    
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func start() {
        let homeModule = DiscoverScreenAssembler.assemble(tmdbService: tmdbService)
        homeModule.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "binoculars.fill"),
            tag: 0
        )
        self.navigationController.viewControllers = [homeModule]
    }
}
