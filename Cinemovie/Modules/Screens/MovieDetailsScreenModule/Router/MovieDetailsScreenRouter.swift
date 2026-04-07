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
    func showRatingPopUP(ratePopupVM: RatePopUpViewModel)
    func showTooltipView(sendedBy view: UIView, message: String)
    func presentAddToListModal(movieID: Int)
}

final class MovieDetailsScreenRouter: MovieDetailsScreenRouterProtocol {
    weak var viewController: MovieDetailsScreenVC?
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    // MARK: - NAVIGATE
    func navigateToSeries(series: TVSeries) {
        let seriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(seriesDetails, animated: true)
    }
    
    func navigateToAnotherMovie(movie: Movie) {
        let newMovieDetails = MovieDetailsScreenAssembler.assemble(movieID: movie.id, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(newMovieDetails, animated: true)
    }
    
    func navigateToPersonDetails(creditID: String) {
        let vc = PersonDetailsScreenAssembler.assemble(creditID: creditID, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - PRESENT
    func showActorPopUp(actor: Cast) {
        guard let vcView = viewController?.view else { return }
        let vm = ActorPopupViewModel(actor: actor, didTapActorDetails: self.navigateToPersonDetails, onClose: self.hideActorPopUp)
        let popupView = ActorPopupView(viewModel: vm)
        popupView.show(in: vcView)
        self.viewController?.activePopUpView = popupView
    }
    
    func showRatingPopUP(ratePopupVM: RatePopUpViewModel) {
        guard let vcView = viewController?.view else { return }
        let popupView = RatePopUpView(viewModel: ratePopupVM)
        popupView.show(in: vcView)
        self.viewController?.activePopUpView = popupView
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
    
    func presentAddToListModal(movieID: Int) {
        let vc = AddToListModalAssembler.assemble(itemID: movieID, mediaType: .movie, networkService: diContainer.networkService)
        vc.modalPresentationStyle = .pageSheet
    
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        viewController?.present(vc, animated: true)
    }
    
    // MARK: - PRIVATE FUNC
    private func hideActorPopUp() {
        DispatchQueue.main.async {
            self.viewController?.activePopUpView?.removeFromSuperview()
            self.viewController?.activePopUpView = nil
        }
    }
}
