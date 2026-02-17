//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenInteractorProtocol: AnyObject {
    // MARK: - WATCHLIST
    func getWatchlistMovies()
    func getWatchlistTVSeries()
    
    // MARK: - FAVORITE
    func getFavoriteMovies()
    func getFavoriteTVSeries()
    
    // MARK: - RATED
    func getRatedMovies()
    func getRatedTVSeries()
    
    // MARK: - USER LIST
    func createNewList(listName: String, listDescription: String?, isPublic: Bool)
    func getUserLists()
    func getUserListDetails(list: UserList)
    func removeUserList(list: UserListDetails)
}

final class MyListsScreenInteractor: MyListsScreenInteractorProtocol {
    weak var presenter: MyListsScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - WATCHLIST
    func getWatchlistMovies() {
        tmdbService.getMoviesInAccountList(listType: .watchlist, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistMovies(success.movies)
            case .failure: presenter?.didGetWatchlistMovies([])
            }
        }
    }
    
    func getWatchlistTVSeries() {
        tmdbService.getSeriesInAccountList(listType: .watchlist, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetWatchlistTVSeries(success.results)
            case .failure: presenter?.didGetWatchlistTVSeries([])
            }
        }
    }
    
    // MARK: - FAVORITE
    func getFavoriteMovies() {
        tmdbService.getMoviesInAccountList(listType: .favorite, page: 1){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteMovies(success.movies)
            case .failure: presenter?.didGetFavoriteMovies([])
            }
        }
    }
    
    func getFavoriteTVSeries() {
        tmdbService.getSeriesInAccountList(listType: .favorite, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetFavoriteTVSeries(success.results)
            case .failure: presenter?.didGetFavoriteTVSeries([])
            }
        }
    }
    
    // MARK: - RATED
    func getRatedMovies() {
        tmdbService.getMoviesInAccountList(listType: .rated, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedMovies(success.movies)
            case .failure: presenter?.didGetRatedMovies([])
            }
        }
    }
    
    func getRatedTVSeries() {
        tmdbService.getSeriesInAccountList(listType: .rated, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetRatedTVSeries(success.results)
            case .failure: presenter?.didGetRatedTVSeries([])
            }
        }
    }
    
    // MARK: - USER LIST
    func createNewList(listName: String, listDescription: String?, isPublic: Bool) {
        tmdbService.createUserList(name: listName, description: listDescription, isPublic: isPublic) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didCreateNewList()
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getUserLists() {
        tmdbService.getUserLists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceieveUserLists(lists: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func removeUserList(list: UserListDetails) {
        tmdbService.removeUserList(listID: list.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.presenter?.didRemoveList()
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getUserListDetails(list: UserList) {
        tmdbService.getUserListDetails(listID: list.id, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveUserListDetails(success)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
