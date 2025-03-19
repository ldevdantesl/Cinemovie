//
//  MovieDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

protocol MovieDetailsScreenRouterProtocol {
    func navigateToAnotherMovie(movie: QueryMovie)
    func presentShareView(movie: MovieDetails)
}

final class MovieDetailsScreenRouter: MovieDetailsScreenRouterProtocol {
    weak var viewController: MovieDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func navigateToAnotherMovie(movie: QueryMovie) {
        let newMovieDetails = MovieDetailsScreenAssembler.assemble(movieID: movie.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newMovieDetails, animated: true)
    }
    
    func presentShareView(movie: MovieDetails) {
        let title = movie.title
        let tagline = movie.tagline
        let overview = movie.overview
        let activityText = "\(title)\n\(tagline)\n\(overview)"
        
        let activityViewController = UIActivityViewController(activityItems: [activityText], applicationActivities: nil)
        viewController?.present(activityViewController, animated: true)
    }
}
