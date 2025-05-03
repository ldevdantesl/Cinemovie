//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol WatchlistScreenInteractorProtocol: AnyObject {
    // MARK: - WATCHLIST
    func getWatchlistMovies(refreshing: Bool)
    func getWatchlistTVSeries(refreshing: Bool)
    
    // MARK: - FAVORITE
    func getFavoriteMovies(refreshing: Bool)
    func getFavoriteTVSeries(refreshing: Bool)
    
    // MARK: - RATED
    func getRatedMovies(refreshing: Bool)
    func getRatedTVSeries(refreshing: Bool)
}

final class WatchlistScreenInteractor: WatchlistScreenInteractorProtocol {
    weak var presenter: WatchlistScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - WATCHLIST
    func getWatchlistMovies(refreshing: Bool) {
        tmdbService.getWatchlistMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getWatchlistTVSeries(refreshing: Bool) {
        tmdbService.getWatchlistTVSeries(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - FAVORITE
    func getFavoriteMovies(refreshing: Bool) {
        tmdbService.getFavoriteMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getFavoriteTVSeries(refreshing: Bool) {
        tmdbService.getFavoriteTVSeries(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - RATED
    func getRatedMovies(refreshing: Bool) {
        tmdbService.getRatedMovies(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetRatedMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getRatedTVSeries(refreshing: Bool) {
        tmdbService.getRatedTVSeries(page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetRatedTVSeries([], refreshing: refreshing)
            }
        }
    }
}
