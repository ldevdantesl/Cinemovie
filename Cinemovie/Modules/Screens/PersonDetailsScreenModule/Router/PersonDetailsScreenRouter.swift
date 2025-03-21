//
//  PersonDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenRouterProtocol {
    func goBack()
    func openSource(sourceID: String, sourceType: ExternalSource.SourceTypes)
}

final class PersonDetailsScreenRouter: PersonDetailsScreenRouterProtocol {
    weak var viewController: PersonDetailsScreenVC?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func openSource(sourceID: String, sourceType: ExternalSource.SourceTypes) {
        var url: URL?
        switch sourceType {
        case .imdb: url = URLHelper.getPersonIMDBURL(withID: sourceID)
        case .wikipedia: url = URLHelper.getPersonWikiURL(withID: sourceID)
        case .facebook: url = URLHelper.getPersonFacebookURL(withID: sourceID)
        case .instagram: url = URLHelper.getPersonInstagramURL(withID: sourceID)
        case .twitter: url = URLHelper.getPersonTwitterURL(withID: sourceID)
        case .youtube: url = URLHelper.getPersonYouTubeURL(withID: sourceID)
        }
        
        guard let url = url else { return }
        AppOpener.openURL(url)
    }
}
