//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol UserListDetailsScreenInteractorProtocol: AnyObject {
    func getInitialListMovies(listType: UserListTypes)
    func getInitialListSeries(listType: UserListTypes)
    
    func getRefreshingListMovies(listType: UserListTypes)
    func getRefreshingListSeries(listType: UserListTypes)
    
    func getPaginatedListMovies(listType: UserListTypes, page: Int)
    func getPaginatedListSeries(listType: UserListTypes, page: Int)
}

final class UserListDetailsScreenInteractor: UserListDetailsScreenInteractorProtocol {
    weak var presenter: UserListDetailsScreenPresenterProtocol?
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - INITIAL
    func getInitialListMovies(listType: UserListTypes) {
        tmdbService.getUserListMovies(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.presenter?.didRecieveInitialMedia(success.movies)
                self.presenter?.didRecieveTotalPages(forType: .movie, totalPages: success.totalPages)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getInitialListSeries(listType: UserListTypes) {
        tmdbService.getUserListSeries(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.presenter?.didRecieveInitialMedia(success.results)
                self.presenter?.didRecieveTotalPages(forType: .tvShow, totalPages: success.totalPages)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - REFRESHINGG
    func getRefreshingListMovies(listType: UserListTypes) {
        tmdbService.getUserListMovies(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecieveRefreshingMedia(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getRefreshingListSeries(listType: UserListTypes) {
        tmdbService.getUserListSeries(listType: listType, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecieveRefreshingMedia(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - PAGINATING
    func getPaginatedListMovies(listType: UserListTypes, page: Int) {
        tmdbService.getUserListMovies(listType: listType, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecievePaginatedMedia(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getPaginatedListSeries(listType: UserListTypes, page: Int) {
        tmdbService.getUserListSeries(listType: listType, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecievePaginatedMedia(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
