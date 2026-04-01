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
    
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func navigateToMovieDetails(movieID: Int) {
        let movieDetails = MovieDetailsScreenAssembler.assemble(movieID: movieID, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    func navigateToTVSeriesDetails(seriesID: Int) {
        let seriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(seriesDetails, animated: true)
    }
    
    func navigateToPersonDetails(personID: Int) {
        let newVC = PersonDetailsScreenAssembler.assemble(personID: personID, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func navigateToSearch() {
        let newVC = SearchScreenAssembler.assemble(tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newVC, animated: true)
    }
}
