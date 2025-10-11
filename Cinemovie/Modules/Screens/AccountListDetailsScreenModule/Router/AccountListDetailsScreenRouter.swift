//
//  WatchlistDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol AccountListDetailsScreenRouterProtocol {
    func goBack()
    func navigateToMovieDetails(movie: Movie)
    func navigateToTVSeriesDetails(series: TVSeries)
}

final class AccountListDetailsScreenRouter: AccountListDetailsScreenRouterProtocol {
    weak var viewController: AccountListDetailsScreenVC?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovieDetails(movie: Movie) {
        let vc = MovieDetailsScreenAssembler.assemble(movie: movie, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTVSeriesDetails(series: TVSeries) {
        let vc = TVSeriesDetailsScreenAssembler.assemble(series: series, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
