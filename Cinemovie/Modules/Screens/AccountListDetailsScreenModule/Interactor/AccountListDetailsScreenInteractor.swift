//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol AccountListDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - INITIAL
    func getInitialListMovies(listType: AccountListTypes)
    func getInitialListSeries(listType: AccountListTypes)
    
    // MARK: - PAGINATION
    func getNewPaginatedMoviesForPage(listType: AccountListTypes, page: Int)
    func getNewPaginatedSeriesForPage(listType: AccountListTypes, page: Int)
    
    // MARK: - REFRESHING
    func getRefreshingListMovies(listType: AccountListTypes)
    func getRefreshingListSeries(listType: AccountListTypes)
}

final class AccountListDetailsScreenInteractor: AccountListDetailsScreenInteractorProtocol {
    weak var presenter: AccountListDetailsScreenPresenterProtocol?
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - ACCOUNT INITIAL
    func getInitialListMovies(listType: AccountListTypes) {
        tmdbService.getMoviesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveMedia(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getInitialListSeries(listType: AccountListTypes) {
        tmdbService.getSeriesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveMedia(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - ACCOUNT PAGINATED
    func getNewPaginatedMoviesForPage(listType: AccountListTypes, page: Int) {
        tmdbService.getMoviesInAccountList(listType: listType, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveNewMedia(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getNewPaginatedSeriesForPage(listType: AccountListTypes, page: Int) {
        tmdbService.getSeriesInAccountList(listType: listType, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveNewMedia(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - ACCOUNT REFRESHING
    func getRefreshingListMovies(listType: AccountListTypes) {
        tmdbService.getMoviesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveRefreshingMedia(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getRefreshingListSeries(listType: AccountListTypes) {
        tmdbService.getSeriesInAccountList(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didReceiveRefreshingMedia(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
