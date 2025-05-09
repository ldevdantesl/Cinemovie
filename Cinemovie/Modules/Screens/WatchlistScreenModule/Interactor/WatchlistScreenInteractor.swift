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
    
    // MARK: - CUSTOM LIST
    func createNewList(listName: String, listDescription: String?, isPublic: Bool)
    func getCustomLists(refreshing: Bool)
}

final class WatchlistScreenInteractor: WatchlistScreenInteractorProtocol {
    weak var presenter: WatchlistScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - WATCHLIST
    func getWatchlistMovies(refreshing: Bool) {
        tmdbService.getUserListMovies(listType: .watchlist, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getWatchlistTVSeries(refreshing: Bool) {
        tmdbService.getUserListSeries(listType: .watchlist, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - FAVORITE
    func getFavoriteMovies(refreshing: Bool) {
        tmdbService.getUserListMovies(listType: .favorite, page: 1){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getFavoriteTVSeries(refreshing: Bool) {
        tmdbService.getUserListSeries(listType: .favorite, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - RATED
    func getRatedMovies(refreshing: Bool) {
        tmdbService.getUserListMovies(listType: .rated, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetRatedMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getRatedTVSeries(refreshing: Bool) {
        tmdbService.getUserListSeries(listType: .rated, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetRatedTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - CUSTOM
    func createNewList(listName: String, listDescription: String?, isPublic: Bool) {
        tmdbService.createCustomList(name: listName, description: listDescription, isPublic: isPublic) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didCreateNewList()
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getCustomLists(refreshing: Bool) {
        tmdbService.getUserCustomLists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceieveCustomLists(lists: success.results, refreshing: refreshing)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
