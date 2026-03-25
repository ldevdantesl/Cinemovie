//
//  HomeScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol DiscoverScreenRouterProtocol {
    func navigateToMovieDetails(movieID: Int)
    func navigateToTVSeriesDetails(seriesID: Int)
    func navigateToPersonDetails(personID: Int)
}

final class DiscoverScreenRouter: DiscoverScreenRouterProtocol {
    weak var viewController: DiscoverScreenVC?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func navigateToMovieDetails(movieID: Int) {
        let movieDetails = MovieDetailsScreenAssembler.assemble(movieID: movieID, networkService: networkService)
        viewController?.navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    func navigateToTVSeriesDetails(seriesID: Int) {
        let seriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, networkService: networkService)
        viewController?.navigationController?.pushViewController(seriesDetails, animated: true)
    }
    
    func navigateToPersonDetails(personID: Int) {
        let newVC = PersonDetailsScreenAssembler.assemble(personID: personID, networkService: networkService)
        viewController?.navigationController?.pushViewController(newVC, animated: true)
    }
}
