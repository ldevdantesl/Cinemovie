//
//  WatchlistDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol AccountListDetailsScreenRouterProtocol {
    func goBack()
    func navigateToMovieDetails(movie: Movie)
    func navigateToTVSeriesDetails(series: TVSeries)
}

final class AccountListDetailsScreenRouter: AccountListDetailsScreenRouterProtocol {
    weak var viewController: AccountListDetailsScreenVC?
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovieDetails(movieId: Int) {
        let vc = MovieDetailsScreenAssembler.assemble(movieID: movieId, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToTVSeriesDetails(seriesID: Int) {
        let vc = TVSeriesDetailsScreenAssembler.assemble(seriesID: seriesID, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
