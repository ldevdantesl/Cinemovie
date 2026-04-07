//
//  SearchScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenRouterProtocol {
    func popBack()
    func pushToMedia(media: MediaProtocol)
}

final class SearchScreenRouter: SearchScreenRouterProtocol {
    weak var viewController: SearchScreenVC?
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func pushToMedia(media: any MediaProtocol) {
        switch media {
        case let movie as Movie:
            let vc = MovieDetailsScreenAssembler.assemble(movieID: movie.id, diContainer: diContainer)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        case let series as TVSeries:
            let vc = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, diContainer: diContainer)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        default: print("Uknown Media Type")
        }
    }
}
