//
//  HomeScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenPresenterProtocol: AnyObject {
    // MARK: - STARTING
    func viewDidLoaded()
    func didTapMovie(_ movie: Movie)
    
    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [Movie])
    func didDownloadUpcomingMovies(queryMovies: [Movie])
    func didDownloadTopRatedMovies(queryMovies: [Movie])
    func didDownloadNowPlayingMovies(queryMovies: [Movie])
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class HomeScreenPresenter {
    weak var view: HomeScreenViewProtocol?
    var router: HomeScreenRouterProtocol
    var interactor: HomeScreenInteractorProtocol

    init(interactor: HomeScreenInteractorProtocol, router: HomeScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomeScreenPresenter: HomeScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        interactor.downloadPopularMovies()
        interactor.downloadUpcomingMovies()
        interactor.downloadTopRatedMovies()
        interactor.downloadNowPlayingMovies()
    }
    
    func didTapMovie(_ movie: Movie) {
        router.navigateToMovieDetails(movieID: movie.id)
    }

    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecievePopularMovies(queryMovies)
        }
    }
    
    func didDownloadUpcomingMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveUpcomingMovies(queryMovies)
        }
    }
    
    func didDownloadTopRatedMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveTopRatedMovies(queryMovies)
        }
    }
    
    func didDownloadNowPlayingMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async {
            self.view?.didRecieveNowPlayingMovies(queryMovies)
        }
    }
    
    func didRecieveError(_ error: Error) {
        DispatchQueue.main.async {
            self.view?.didRecieveError(error.localizedDescription)
        }
    }
}
