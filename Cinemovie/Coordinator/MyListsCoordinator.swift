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
    weak var sessionDelegate: SessionDelegate?
    
    init(diContainer: DIContainer, sessionDelegate: SessionDelegate?) {
        self.diContainer = diContainer
        self.sessionDelegate = sessionDelegate
    }
    
    func start() {
        let watchlistModule = MyListsScreenAssembler.assemble(diContainer: diContainer, sessionDelegate: sessionDelegate)
        watchlistModule.tabBarItem = UITabBarItem(
            title: "My Lists",
            image: UIImage(systemName: "film.stack"),
            tag: 1
        )
        self.navigationController.viewControllers = [watchlistModule]
    }
}
