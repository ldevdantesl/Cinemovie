//
//  MovieDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit

protocol MovieDetailsScreenRouterProtocol {
    func goBack()
    func navigateToPersonDetails(creditID: String)
    func navigateToAnotherMovie(movie: Movie)
    func presentShareView(movie: MovieDetails)
    func presentActor(actor: Cast)
}

final class MovieDetailsScreenRouter: MovieDetailsScreenRouterProtocol {
    weak var viewController: MovieDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func navigateToPerson(personID: Int) { }
    
    func navigateToAnotherMovie(movie: Movie) {
        let newMovieDetails = MovieDetailsScreenAssembler.assemble(movieID: movie.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newMovieDetails, animated: true)
    }
    
    func presentActor(actor: Cast) {
        let vm = MovieDetailsActorPopupViewModel(actor: actor, didTapActorDetails: navigateToPersonDetails)
        let popupView = MovieDetailsActorPopupView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.configure(viewModel: vm)

        viewController?.view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        popupView.alpha = 0
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            popupView.alpha = 1
            popupView.transform = .identity
        }
    }
    
    func navigateToPersonDetails(creditID: String) {
        let vc = PersonDetailsScreenAssembler.assemble(creditID: creditID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentShareView(movie: MovieDetails) {
        let title = movie.title
        let tagline = movie.tagline
        let overview = movie.overview
        let activityText = "\(title)\n\(tagline)\n\(overview)"
        
        let activityViewController = UIActivityViewController(activityItems: [activityText], applicationActivities: nil)
        viewController?.present(activityViewController, animated: true)
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
