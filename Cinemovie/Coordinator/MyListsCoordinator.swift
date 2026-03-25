//
//  WatchlistCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import UIKit

final class MyListsCoordinator: CoordinatorProtocol {
    let navigationController: UINavigationController = UINavigationController()
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func start() {
        let watchlistModule = MyListsScreenAssembler.assemble(networkService: networkService)
        watchlistModule.tabBarItem = UITabBarItem(
            title: "My Lists",
            image: UIImage(systemName: "film.stack"),
            tag: 1
        )
        self.navigationController.viewControllers = [watchlistModule]
    }
}
