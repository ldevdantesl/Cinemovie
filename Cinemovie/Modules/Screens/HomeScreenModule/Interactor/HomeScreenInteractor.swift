//
//  HomeScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenInteractorProtocol: AnyObject {
    // MARK: - MOVIES
    func downloadPopularMovies()
    func downloadUpcomingMovies()
    func downloadTopRatedMovies()
    func downloadNowPlayingMovies()
    
    // MARK: - TV SERIES
    func downloadPopularTVSeries()
    func downloadAiringTodayTVSeries()
    func downloadTopRatedTVSeries()
    func downloadOnTheAirTVSeries()
}

final class HomeScreenInteractor: HomeScreenInteractorProtocol {
    weak var presenter: HomeScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - MOVIES
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
    
    // MARK: - TV SERIES
    func downloadPopularTVSeries() {
        tmdbService?.getPopularTVSeries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadPopularTVSeries(querySeries: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadTopRatedTVSeries() {
        tmdbService?.getTopRatedTVSeries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadTopRatedTVSeries(querySeries: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadAiringTodayTVSeries() {
        tmdbService?.getAiringTodayTVSeries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadAiringTodayTVSeries(querySeries: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadOnTheAirTVSeries() {
        tmdbService?.getOnTheAirTVSeries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadOnTheAirTVSeries(querySeries: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
