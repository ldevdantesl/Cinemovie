//
//  WatchlistCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import UIKit

final class MyListsCoordinator: Coordinator {
    let navigationController: UINavigationController = UINavigationController()
    
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func start() {
        let watchlistModule = MyListsScreenAssembler.assemble(tmdbService: tmdbService)
        watchlistModule.tabBarItem = UITabBarItem(
            title: "My Lists",
            image: UIImage(systemName: "film.stack"),
            tag: 1
        )
        self.navigationController.viewControllers = [watchlistModule]
    }
}
