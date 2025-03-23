//
//  TVSeriesDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit
protocol TVSeriesDetailsScreenRouterProtocol {
    func goBack()
    
    func navigateToPersonDetails(creditID: String)
    func navigateToAnotherTVSeries(series: TVSeries)
    func presentShareView(details: TVSeriesDetails)
    func presentActor(actor: Cast)
}

final class TVSeriesDetailsScreenRouter: TVSeriesDetailsScreenRouterProtocol {
    weak var viewController: TVSeriesDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func navigateToPerson(personID: Int) { }
    
    func navigateToAnotherTVSeries(series: TVSeries) {
        let newSeriesDetails = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, tmdbService: tmdbService)
        viewController?.navigationController?.pushViewController(newSeriesDetails, animated: true)
    }
    
    func presentActor(actor: Cast) {
        let vm = MediaDetailsActorPopupViewModel(actor: actor, didTapActorDetails: navigateToPersonDetails)
        let popupView = MediaDetailsActorPopupView()
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
}
