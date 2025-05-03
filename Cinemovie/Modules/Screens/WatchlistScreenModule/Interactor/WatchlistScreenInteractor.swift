//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenInteractorProtocol: AnyObject {
    func getWatchlistMovies(refreshing: Bool)
    func getFavoriteMovies(refreshing: Bool)
    func getRatedMovies(refreshing: Bool)
}

final class WatchlistScreenInteractor: WatchlistScreenInteractorProtocol {
    weak var presenter: WatchlistScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func getWatchlistMovies(refreshing: Bool) {
        tmdbService.getWatchlistMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getFavoriteMovies(refreshing: Bool) {
        tmdbService.getFavoriteMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getRatedMovies(refreshing: Bool) {
        tmdbService.getRatedMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetRatedMovies([], refreshing: refreshing)
            }
        }
    }
}
