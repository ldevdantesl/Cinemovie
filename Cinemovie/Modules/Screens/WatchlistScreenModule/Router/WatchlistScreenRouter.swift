//
//  WatchlistScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenRouterProtocol {
    func navigateToList(listType: UserListTypes)
}

final class WatchlistScreenRouter: WatchlistScreenRouterProtocol {
    weak var viewController: WatchlistScreenVC?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func navigateToList(listType: UserListTypes) {
        let vc = UserListDetailsScreenAssembler.assemble(listType: listType, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
