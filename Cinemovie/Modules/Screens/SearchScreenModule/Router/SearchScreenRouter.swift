//
//  SearchScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenRouterProtocol {
    func popBack()
    func pushToMedia(media: Media)
}

final class SearchScreenRouter: SearchScreenRouterProtocol {
    private var tmdbService: TMDBService
    weak var viewController: SearchScreenVC?
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func pushToMedia(media: any Media) {
        switch media {
        case let movie as Movie:
            let vc = MovieDetailsScreenAssembler.assemble(movie: movie, tmdbService: tmdbService)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        case let series as TVSeries:
            let vc = TVSeriesDetailsScreenAssembler.assemble(series: series, tmdbService: tmdbService)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        default: print("Uknown Media Type")
        }
    }
}
