//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenInteractorProtocol: AnyObject {
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
    func removeCustomList(list: UserList)
}

final class MyListsScreenInteractor: MyListsScreenInteractorProtocol {
    weak var presenter: MyListsScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - WATCHLIST
    func getWatchlistMovies(refreshing: Bool) {
        tmdbService.getMoviesInAccountList(listType: .watchlist, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getWatchlistTVSeries(refreshing: Bool) {
        tmdbService.getSeriesInAccountList(listType: .watchlist, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetWatchlistTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - FAVORITE
    func getFavoriteMovies(refreshing: Bool) {
        tmdbService.getMoviesInAccountList(listType: .favorite, page: 1){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getFavoriteTVSeries(refreshing: Bool) {
        tmdbService.getSeriesInAccountList(listType: .favorite, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetFavoriteTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - RATED
    func getRatedMovies(refreshing: Bool) {
        tmdbService.getMoviesInAccountList(listType: .rated, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedMovies(success.movies, refreshing: refreshing)
            case .failure: presenter?.didGetRatedMovies([], refreshing: refreshing)
            }
        }
    }
    
    func getRatedTVSeries(refreshing: Bool) {
        tmdbService.getSeriesInAccountList(listType: .rated, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedTVSeries(success.results, refreshing: refreshing)
            case .failure: presenter?.didGetRatedTVSeries([], refreshing: refreshing)
            }
        }
    }
    
    // MARK: - CUSTOM
    func createNewList(listName: String, listDescription: String?, isPublic: Bool) {
        tmdbService.createUserList(name: listName, description: listDescription, isPublic: isPublic) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didCreateNewList()
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getCustomLists(refreshing: Bool) {
        tmdbService.getUserLists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceieveCustomLists(lists: success.results, refreshing: refreshing)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func removeCustomList(list: UserList) {
        tmdbService.removeUserList(listID: list.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didRemoveList()
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
