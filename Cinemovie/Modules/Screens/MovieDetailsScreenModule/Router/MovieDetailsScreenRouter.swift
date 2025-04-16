//
//  MovieDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit
import SnapKit

protocol MovieDetailsScreenRouterProtocol {
    // MARK: - NAVIGATION
    func goBack()
    func navigateToPersonDetails(creditID: String)
    func navigateToAnotherMovie(movie: Movie)
    func navigateToSeries(series: TVSeries)
    
    // MARK: - PRESENT
    func presentShareView(movie: MovieDetails)
    func showActorPopUp(actor: Cast)
    func showTooltipView(sendedBy view: UIView, message: String)
}

final class MovieDetailsScreenRouter: MovieDetailsScreenRouterProtocol {
    weak var viewController: MovieDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func navigateToSeries(series: TVSeries) {
        let seriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(seriesDetails, animated: true)
    }
    
    func navigateToAnotherMovie(movie: Movie) {
        let newMovieDetails = MovieDetailsScreenAssembler.assemble(movieID: movie.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newMovieDetails, animated: true)
    }
    
    func showActorPopUp(actor: Cast) {
        guard let vcView = viewController?.view else { return }
        let vm = ActorPopupViewModel(actor: actor, didTapActorDetails: self.navigateToPersonDetails, didTapClose: self.hideActorPopUp)
        let popupView = ActorPopupView(viewModel: vm)
        popupView.show(in: vcView)
        self.viewController?.activePopUpView = popupView
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
    
    func showTooltipView(sendedBy view: UIView, message: String) {
        guard let vcView = viewController?.view else { return }
        viewController?.activeTooltipWorkItem?.cancel()
        viewController?.activeTooltipView?.dismiss()
        
        var tooltipMsg: String = "Unknown"
        switch message {
        case "ReleaseYearLabel": tooltipMsg = "Release year"
        case "ReleasedImage": tooltipMsg = "Movie is Released"
        case "NotReleasedImage": tooltipMsg = "Not Released Yet"
        case "DurationLabel": tooltipMsg = "Movie Duration"
        case "HDStatusImage": tooltipMsg = "HD Resolution Available"
        case "MediaTypeImage": tooltipMsg = "Is Movie"
        default: break
        }
        
        let tooltip = CMTooltipView(text: tooltipMsg)
        tooltip.show(from: view, in: vcView)
        viewController?.activeTooltipView = tooltip
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            viewController?.activeTooltipView?.dismiss()
            viewController?.activeTooltipView = nil
        }
        viewController?.activeTooltipWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
    }
    
    // MARK: - PRIVATE FUNC
    private func hideActorPopUp() {
        DispatchQueue.main.async {
            self.viewController?.activePopUpView?.removeFromSuperview()
            self.viewController?.activePopUpView = nil
        }
    }
}
