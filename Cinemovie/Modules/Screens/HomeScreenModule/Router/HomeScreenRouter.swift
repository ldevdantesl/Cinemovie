//
//  HomeScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenRouterProtocol {
    func navigateToMovieDetails(movieID: Int)
}

final class HomeScreenRouter: HomeScreenRouterProtocol {
    weak var viewController: HomeScreenVC?
    
    private let tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func navigateToMovieDetails(movieID: Int) {
        let movieDetails = MovieDetailsScreenAssembler.assemble(movieID: movieID, tmdbService: tmdbService)
        movieDetails.modalPresentationStyle = .pageSheet
        viewController?.present(UINavigationController(rootViewController: movieDetails), animated: true)
    }
}
