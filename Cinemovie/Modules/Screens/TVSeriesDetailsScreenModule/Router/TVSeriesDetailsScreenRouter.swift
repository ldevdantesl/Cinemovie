//
//  TVSeriesDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
protocol TVSeriesDetailsScreenRouterProtocol {
    func goBack()
    
    func openHomepage(homepage: String)
    func showTooltipView(sendedBy view: UIView, message: String)
    func navigateToPersonDetails(creditID: String)
    func navigateToAnotherTVSeries(series: TVSeries)
    func presentShareView(details: TVSeriesDetails)
    func showActorPopUp(actor: Cast)
}

final class TVSeriesDetailsScreenRouter: TVSeriesDetailsScreenRouterProtocol {
    weak var viewController: TVSeriesDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func navigateToAnotherTVSeries(series: TVSeries) {
        let newSeriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newSeriesDetails, animated: true)
    }
    
    func showActorPopUp(actor: Cast) {
        guard let vcView = viewController?.view else { return }
        let vm = MediaDetailsActorPopupViewModel(actor: actor, didTapActorDetails: self.navigateToPersonDetails, didTapClose: self.hideActorPopUp)
        let popupView = MediaDetailsActorPopupView(viewModel: vm)
        popupView.show(in: vcView)
        viewController?.activeActorPopUpView = popupView
    }
    
    func navigateToPersonDetails(creditID: String) {
        let vc = PersonDetailsScreenAssembler.assemble(creditID: creditID, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentShareView(details: TVSeriesDetails) {
        let title = details.name
        let tagline = details.tagline
        let overview = details.overview
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
        case "AirDateLabel": tooltipMsg = "First Aired Year"
        case "TVSeriesStatus_Cancelled": tooltipMsg = "Series Was Canceled"
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
    
    func openHomepage(homepage: String) {
        guard let url = URLHelper.stringToURL(urlString: homepage) else { return }
        AppOpener.openURL(url)
    }
    
    // MARK: - PRIVATE FUNC
    private func hideActorPopUp() {
        self.viewController?.activeActorPopUpView = nil
    }
}
