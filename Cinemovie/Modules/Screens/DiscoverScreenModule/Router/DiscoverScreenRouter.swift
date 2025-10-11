//
//  HomeScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol DiscoverScreenRouterProtocol {
    func navigateToMovieDetails(movie: Movie)
    func navigateToTVSeriesDetails(series: TVSeries)
    func navigateToPersonDetails(personID: Int)
    func navigateToSearch()
}

final class DiscoverScreenRouter: DiscoverScreenRouterProtocol {
    weak var viewController: DiscoverScreenVC?
    
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func navigateToMovieDetails(movie: Movie) {
        let movieDetails = MovieDetailsScreenAssembler.assemble(movie: movie, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    func navigateToTVSeriesDetails(series: TVSeries) {
        let seriesDetails = TVSeriesDetailsScreenAssembler.assemble(series: series, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(seriesDetails, animated: true)
    }
    
    func navigateToPersonDetails(personID: Int) {
        let newVC = PersonDetailsScreenAssembler.assemble(personID: personID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func navigateToSearch() {
        let newVC = SearchScreenAssembler.assemble(tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newVC, animated: true)
    }
}
