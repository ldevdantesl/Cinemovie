//
//  HomeScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenRouterProtocol {
    func navigateToMovieDetails(movieID: Int)
    func navigateToTVSeriesDetails(seriesID: Int)
    func navigateToPersonDetails(personID: Int)
}

final class HomeScreenRouter: HomeScreenRouterProtocol {
    weak var viewController: HomeScreenVC?
    
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func navigateToMovieDetails(movieID: Int) {
        let movieDetails = MovieDetailsScreenAssembler.assemble(movieID: movieID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    func navigateToTVSeriesDetails(seriesID: Int) {
        let seriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(seriesDetails, animated: true)
    }
    
    func navigateToPersonDetails(personID: Int) {
        let newVC = PersonDetailsScreenAssembler.assemble(personID: personID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newVC, animated: true)
    }
}
