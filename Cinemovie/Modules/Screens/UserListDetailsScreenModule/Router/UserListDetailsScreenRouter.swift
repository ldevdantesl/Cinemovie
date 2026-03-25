//
//  UserListDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit

protocol UserListDetailsScreenRouterProtocol {
    func goBack()
    
    func navigateToMovie(movie: Movie)
    func navigateToSeries(series: TVSeries)
}

final class UserListDetailsScreenRouter: UserListDetailsScreenRouterProtocol {
    weak var viewController: UserListDetailsScreenVC?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovie(movie: Movie) {
        let vc = MovieDetailsScreenAssembler.assemble(movieID: movie.id, networkService: networkService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSeries(series: TVSeries) {
        let vc = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, networkService: networkService)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
