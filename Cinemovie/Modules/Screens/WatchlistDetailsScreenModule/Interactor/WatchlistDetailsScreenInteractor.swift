//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol WatchlistDetailsScreenInteractorProtocol: AnyObject {
    func getListMovies(listType: UserListTypes, refreshing: Bool)
    func getListSeries(listType: UserListTypes, refreshing: Bool)
}

final class WatchlistDetailsScreenInteractor: WatchlistDetailsScreenInteractorProtocol {
    weak var presenter: WatchlistDetailsScreenPresenterProtocol?
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func getListMovies(listType: UserListTypes, refreshing: Bool) {
        switch listType {
        case .watchlist:
            tmdbService.getWatchlistMovies(page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success): self.presenter?.didRecieveMedia(success.movies, refreshing: refreshing)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        case .favorite:
            tmdbService.getFavoriteMovies(page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success): self.presenter?.didRecieveMedia(success.movies, refreshing: refreshing)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        case .rated:
            tmdbService.getRatedMovies(page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success): self.presenter?.didRecieveMedia(success.movies, refreshing: refreshing)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        case .custom:
            break
        }
    }
    
    func getListSeries(listType: UserListTypes, refreshing: Bool) {
        switch listType {
        case .watchlist:
            tmdbService.getWatchlistTVSeries(page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success): self.presenter?.didRecieveMedia(success.results, refreshing: refreshing)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        case .favorite:
            tmdbService.getFavoriteTVSeries(page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success): self.presenter?.didRecieveMedia(success.results, refreshing: refreshing)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        case .rated:
            tmdbService.getRatedTVSeries(page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success): self.presenter?.didRecieveMedia(success.results, refreshing: refreshing)
                case .failure(let failure): self.presenter?.didRecieveError(failure)
                }
            }
        case .custom:
            break
        }
    }
}
