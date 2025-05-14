//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol UserListDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - ACCOUNT INITIAL
    func getInitialListMovies(listType: AccountListTypes)
    func getInitialListSeries(listType: AccountListTypes)
    
    // MARK: - ACCOUNT PAGINATION
    func getNewPaginatedMoviesForPage(listType: AccountListTypes, page: Int)
    func getNewPaginatedSeriesForPage(listType: AccountListTypes, page: Int)
    
    // MARK: - ACCOUNT REFRESHING
    func getRefreshingListMovies(listType: AccountListTypes)
    func getRefreshingListSeries(listType: AccountListTypes)
    
    // MARK: - USER LIST
    func getUserListDetails(listID: Int)
}

final class UserListDetailsScreenInteractor: UserListDetailsScreenInteractorProtocol {
    weak var presenter: UserListDetailsScreenPresenterProtocol?
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - ACCOUNT INITIAL
    func getInitialListMovies(listType: AccountListTypes) {
        tmdbService.getMoviesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.presenter?.didRecieveMovies(success.movies)
                self.presenter?.didRecieveTotalPages(forType: .movie, totalPages: success.totalPages)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getInitialListSeries(listType: AccountListTypes) {
        tmdbService.getSeriesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.presenter?.didRecieveTVSeries(success.results)
                self.presenter?.didRecieveTotalPages(forType: .tvShow, totalPages: success.totalPages)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - ACCOUNT PAGINATED
    func getNewPaginatedMoviesForPage(listType: AccountListTypes, page: Int) {
        tmdbService.getMoviesInAccountList(listType: listType, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveNewMovies(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getNewPaginatedSeriesForPage(listType: AccountListTypes, page: Int) {
        tmdbService.getSeriesInAccountList(listType: listType, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveNewSeries(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - ACCOUNT REFRESHING
    func getRefreshingListMovies(listType: AccountListTypes) {
        tmdbService.getMoviesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveRefreshingMovies(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getRefreshingListSeries(listType: AccountListTypes) {
        tmdbService.getSeriesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveRefreshingSeries(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - USER LIST
    func getUserListDetails(listID: Int) {
        tmdbService.getUserListDetails(listID: listID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): break // self.presenter?.didReceiveMedia(media: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
