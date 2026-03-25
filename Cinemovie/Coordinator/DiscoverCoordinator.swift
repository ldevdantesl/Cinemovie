//
//  HomeCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class DiscoverCoordinator: CoordinatorProtocol {
    let navigationController: UINavigationController = UINavigationController()
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func start() {
        let homeModule = DiscoverScreenAssembler.assemble(networkService: networkService)
        homeModule.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "binoculars.fill"),
            tag: 0
        )
        self.navigationController.viewControllers = [homeModule]
    }
}
