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
    func didDownloadPopularMovies(withError error: NetworkError)
    
    func didDownloadUpcomingMovies(queryMovies: [Movie])
    func didDownloadUpcomingMovies(withError error: NetworkError)
    
    func didDownloadTopRatedMovies(queryMovies: [Movie])
    func didDownloadTopRatedMovies(withError error: NetworkError)
    
    func didDownloadNowPlayingMovies(queryMovies: [Movie])
    func didDownloadNowPlayingMovies(withError error: NetworkError)
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
    
    func didDownloadPopularMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    func didDownloadUpcomingMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveUpcomingMovies(queryMovies)
        }
    }
    
    func didDownloadUpcomingMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    func didDownloadTopRatedMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveTopRatedMovies(queryMovies)
        }
    }
    
    func didDownloadTopRatedMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    func didDownloadNowPlayingMovies(queryMovies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveNowPlayingMovies(queryMovies)
        }
    }
    
    func didDownloadNowPlayingMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    private func recieveErrorHandler(_ error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveError(error.localizedDescription)
        }
    }
}
