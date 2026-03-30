//
//  WatchlistCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import UIKit

final class MyListsCoordinator {
    lazy var navigationController: UINavigationController = UINavigationController()
    
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func start() {
        let watchlistModule = MyListsScreenAssembler.assemble(diContainer: diContainer)
        watchlistModule.tabBarItem = UITabBarItem(
            title: "My Lists",
            image: UIImage(systemName: "film.stack"),
            tag: 1
        )
        self.navigationController.viewControllers = [watchlistModule]
    }
}
