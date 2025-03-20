//
//  PersonDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenRouterProtocol { }

final class PersonDetailsScreenRouter: PersonDetailsScreenRouterProtocol {
    weak var viewController: PersonDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
}
