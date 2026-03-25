//
//  PersonDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenRouterProtocol {
    func goBack()
    func openSource(sourceID: String, sourceType: SourceTypes)
    func navigateToMovie(movieID: Int)
    func navigateToSeries(seriesID: Int)
}

final class PersonDetailsScreenRouter: PersonDetailsScreenRouterProtocol {
    weak var viewController: PersonDetailsScreenVC?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovie(movieID: Int) {
        let movieDetailsVC = MovieDetailsScreenAssembler.assemble(movieID: movieID, networkService: networkService)
        viewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func openSource(sourceID: String, sourceType: SourceTypes) {
        var url: URL?
        switch sourceType {
        case .imdb: url = URLHelper.getPersonIMDBURL(withID: sourceID)
        case .wikipedia: url = URLHelper.getPersonWikiURL(withID: sourceID)
        case .facebook: url = URLHelper.getPersonFacebookURL(withID: sourceID)
        case .instagram: url = URLHelper.getPersonInstagramURL(withID: sourceID)
        case .tiktok: url = URLHelper.getPersonTikTokURL(withID: sourceID)
        }
        
        guard let url = url else { return }
        AppOpener.openURL(url)
    }
    
    func navigateToSeries(seriesID: Int) {
        let seriesVC = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, networkService: networkService)
        viewController?.navigationController?.pushViewController(seriesVC, animated: true)
    }
}
