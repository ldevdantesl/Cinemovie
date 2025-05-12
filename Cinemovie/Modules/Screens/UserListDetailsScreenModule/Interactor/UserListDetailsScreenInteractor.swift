//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol UserListDetailsScreenInteractorProtocol: AnyObject {
    func getInitialListMovies(listType: AccountListTypes)
    func getInitialListSeries(listType: AccountListTypes)
}

final class UserListDetailsScreenInteractor: UserListDetailsScreenInteractorProtocol {
    weak var presenter: UserListDetailsScreenPresenterProtocol?
    private var tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - INITIAL
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
}
