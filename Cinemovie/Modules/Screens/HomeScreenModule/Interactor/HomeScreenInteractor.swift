//
//  HomeScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenInteractorProtocol: AnyObject {
    func downloadPopularMovies()
    func downloadUpcomingMovies()
    func downloadTopRatedMovies()
    func downloadNowPlayingMovies()
}

final class HomeScreenInteractor: HomeScreenInteractorProtocol {
    weak var presenter: HomeScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func downloadPopularMovies() {
        tmdbService?.getPopularMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadPopularMovies(queryMovies: success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadUpcomingMovies() {
        tmdbService?.getUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadUpcomingMovies(queryMovies: success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadTopRatedMovies() {
        tmdbService?.getTopRatedMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadTopRatedMovies(queryMovies: success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadNowPlayingMovies() {
        tmdbService?.getNowPlayingMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadNowPlayingMovies(queryMovies: success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
