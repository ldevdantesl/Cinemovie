//
//  TVSeriesDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

protocol TVSeriesDetailsScreenRouterProtocol {
}

final class TVSeriesDetailsScreenRouter: TVSeriesDetailsScreenRouterProtocol {
    weak var viewController: TVSeriesDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
}
