//
//  TVSeriesDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
protocol TVSeriesDetailsScreenRouterProtocol {
    // MARK: - NAVIGATION
    func goBack()
    func navigateToPersonDetails(creditID: String)
    func navigateToAnotherTVSeries(series: TVSeries)
    func navigateToMovie(movie: Movie)
    
    // MARK: - PRESENT
    func showTooltipView(sendedBy view: UIView, message: String)
    func presentShareView(details: TVSeriesDetails)
    func showActorPopUp(actor: Cast)
    func showSeasonPopUp(seasonDetails: TVSeasonDetails)
    
    // MARK: - ROUTE
    func openHomepage(homepage: String)
}

final class TVSeriesDetailsScreenRouter: TVSeriesDetailsScreenRouterProtocol {
    weak var viewController: TVSeriesDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - NAVIGATION
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToAnotherTVSeries(series: TVSeries) {
        let newSeriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newSeriesDetails, animated: true)
    }
    
    func navigateToPersonDetails(creditID: String) {
        let vc = PersonDetailsScreenAssembler.assemble(creditID: creditID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMovie(movie: Movie) {
        let movieDetailsVC = MovieDetailsScreenAssembler.assemble(movieID: movie.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    // MARK: - PRESENT
    func showActorPopUp(actor: Cast) {
        guard let vcView = viewController?.view else { return }
        let vm = ActorPopupViewModel(actor: actor, didTapActorDetails: self.navigateToPersonDetails, didTapClose: self.hidePopUpView)
        let popupView = ActorPopupView(viewModel: vm)
        popupView.show(in: vcView)
        viewController?.activePopUpView = popupView
    }
    
    func showSeasonPopUp(seasonDetails: TVSeasonDetails) {
        DispatchQueue.main.async {
            guard let vcView = self.viewController?.view else { return }
            let vm = SeasonsPopUpViewModel(seasonDetails: seasonDetails, didTapClose: self.hidePopUpView)
            let popupView = SeasonsPopUpView(viewModel: vm)
            popupView.show(in: vcView)
            self.viewController?.activePopUpView = popupView
        }
    }
    
    func presentShareView(details: TVSeriesDetails) {
        let title = details.name
        let tagline = details.tagline
        let overview = details.overview
        let activityText = "\(title)\n\(tagline ?? "")\n\(overview)"
        
        let activityViewController = UIActivityViewController(activityItems: [activityText], applicationActivities: nil)
        viewController?.present(activityViewController, animated: true)
    }
    
    func showTooltipView(sendedBy view: UIView, message: String) {
        guard let vcView = viewController?.view else { return }
        viewController?.activeTooltipWorkItem?.cancel()
        viewController?.activeTooltipView?.dismiss()
    
        var tooltipMsg: String = "Unknown"
        switch message {
        case "AirDateLabel": tooltipMsg = "First Aired Year"
        case "TVSeriesStatus_Canceled": tooltipMsg = "Series Was Cancelled"
        case "TVSeriesStatus_In Production": tooltipMsg = "Currently In Production"
        case "TVSeriesStatus_Returning Series": tooltipMsg = "Actively Airing"
        case "TVSeriesStatus_Planned": tooltipMsg = "Only Announced"
        case "TVSeriesStatus_Pilot": tooltipMsg = "Pilot Episode Only"
        case "TVSeriesStatus_Ended": tooltipMsg = "Series has concluded"
        case "SeriesDurationLabel": tooltipMsg = "Total Seasons"
        case "HDStatusImage": tooltipMsg = "HD Resolution Available"
        case "MediaTypeImage": tooltipMsg = "Is TV Series"
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
    
    // MARK: - ROUTE
    func openHomepage(homepage: String) {
        guard let url = URLHelper.stringToURL(urlString: homepage) else { return }
        AppOpener.openURL(url)
    }
    
    // MARK: - PRIVATE FUNC
    private func hidePopUpView() {
        self.viewController?.activePopUpView = nil
    }
}
