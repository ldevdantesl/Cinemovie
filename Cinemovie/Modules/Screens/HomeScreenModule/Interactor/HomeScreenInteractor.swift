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
            self?.downloadHandler(
                result: result,
                success: { movies in self?.presenter?.didDownloadPopularMovies(queryMovies: movies) },
                failure: { error in self?.presenter?.didDownloadPopularMovies(withError: error) }
            )
        }
    }
    
    func downloadUpcomingMovies() {
        tmdbService?.getUpcomingMovies { [weak self] result in
            self?.downloadHandler(
                result: result,
                success: { movies in self?.presenter?.didDownloadUpcomingMovies(queryMovies: movies) },
                failure: { error in self?.presenter?.didDownloadUpcomingMovies(withError: error) }
            )
        }
    }
    
    func downloadTopRatedMovies() {
        tmdbService?.getTopRatedMovies { [weak self] result in
            self?.downloadHandler(
                result: result,
                success: { movies in self?.presenter?.didDownloadTopRatedMovies(queryMovies: movies) },
                failure: { error in self?.presenter?.didDownloadTopRatedMovies(withError: error) }
            )
        }
    }
    
    func downloadNowPlayingMovies() {
        tmdbService?.getNowPlayingMovies { [weak self] result in
            self?.downloadHandler(
                result: result,
                success: { movies in self?.presenter?.didDownloadNowPlayingMovies(queryMovies: movies) },
                failure: { error in self?.presenter?.didDownloadNowPlayingMovies(withError: error) }
            )
        }
    }
    
    private func downloadHandler(
        result: Result<MovieListsAPIResponse, NetworkError>,
        success: ([QueryMovie]) -> Void,
        failure: (NetworkError) -> Void
    ) {
        switch result {
        case .success(let response): success(response.movies)
        case .failure(let error): failure(error)
        }
    }
}
