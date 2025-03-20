//
//  MovieDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit

protocol MovieDetailsScreenRouterProtocol {
    func navigateToAnotherMovie(movie: QueryMovie)
    func presentShareView(movie: MovieDetails)
    func presentActor(actor: Cast)
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
    
    func presentActor(actor: Cast) {
        if let existingPopup = viewController?.view.subviews.first(where: { $0 is MovieDetailsActorPopupView }) as? MovieDetailsActorPopupView {
            existingPopup.removeFromSuperview()
        }

        let vm = MovieDetailsActorPopupViewModel(actor: actor, didTapActorDetails: nil)
        let popupView = MovieDetailsActorPopupView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.configure(viewModel: vm)

        viewController?.view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        popupView.alpha = 0
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            popupView.alpha = 1
            popupView.transform = .identity
        }
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
