//
//  HomeScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol HomeScreenRouterProtocol {
    func navigateToMovieDetails(movieID: Int)
}

final class HomeScreenRouter: HomeScreenRouterProtocol {
    weak var viewController: HomeScreenVC?
    
    func navigateToMovieDetails(movieID: Int) {
        let movieDetails = MovieDetailsScreenAssembler.assemble(movieID: movieID)
        movieDetails.modalPresentationStyle = .fullScreen
        viewController?.present(movieDetails, animated: true)
    }
}
