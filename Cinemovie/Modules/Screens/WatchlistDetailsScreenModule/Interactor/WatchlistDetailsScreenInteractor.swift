//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol WatchlistDetailsScreenInteractorProtocol: AnyObject {
    func getWatchlistMovies(refreshing: Bool)
    func getWatchlistSeries(refreshing: Bool)
}

final class WatchlistDetailsScreenInteractor: WatchlistDetailsScreenInteractorProtocol {
    weak var presenter: WatchlistDetailsScreenPresenterProtocol?
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func getWatchlistMovies(refreshing: Bool) {
        tmdbService.getWatchlistMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecieveMedia(success.movies, refreshing: refreshing)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getWatchlistSeries(refreshing: Bool) {
        tmdbService.getWatchlistTVSeries(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecieveMedia(success.results, refreshing: refreshing)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
