//
//  WatchlistCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 22.04.2025.
//

import UIKit

final class WatchlistCoordinator: Coordinator {
    let navigationController: UINavigationController = UINavigationController()
    
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func start() {
        let watchlistModule = WatchlistScreenAssembler.assemble(tmdbService: tmdbService)
        watchlistModule.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(systemName: "bookmark.fill"),
            tag: 1
        )
        self.navigationController.viewControllers = [watchlistModule]
    }
}
