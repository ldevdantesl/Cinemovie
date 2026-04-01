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
    func navigateToMovie(movie: Movie)
    func navigateToSeries(series: TVSeries)
}

final class PersonDetailsScreenRouter: PersonDetailsScreenRouterProtocol {
    weak var viewController: PersonDetailsScreenVC?
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovie(movieID: Int) {
        let movieDetailsVC = MovieDetailsScreenAssembler.assemble(movieID: movieID, diContainer: diContainer)
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
        let seriesVC = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(seriesVC, animated: true)
    }
}
