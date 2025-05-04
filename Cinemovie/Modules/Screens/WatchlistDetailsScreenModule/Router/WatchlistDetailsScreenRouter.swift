//
//  WatchlistDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol WatchlistDetailsScreenRouterProtocol {
    func goBack()
    func navigateToMovieDetails(movieId: Int)
    func navigateToTVSeriesDetails(seriesID: Int)
}

final class WatchlistDetailsScreenRouter: WatchlistDetailsScreenRouterProtocol {
    weak var viewController: WatchlistDetailsScreenVC?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovieDetails(movieId: Int) {
        let vc = MovieDetailsScreenAssembler.assemble(movieID: movieId, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTVSeriesDetails(seriesID: Int) {
        let vc = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
