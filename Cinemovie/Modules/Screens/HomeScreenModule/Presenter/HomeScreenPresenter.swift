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
    
    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [QueryMovie])
    func didDownloadPopularMovies(withError error: NetworkError)
    
    func didDownloadUpcomingMovies(queryMovies: [QueryMovie])
    func didDownloadUpcomingMovies(withError error: NetworkError)
    
    func didDownloadTopRatedMovies(queryMovies: [QueryMovie])
    func didDownloadTopRatedMovies(withError error: NetworkError)
    
    func didDownloadNowPlayingMovies(queryMovies: [QueryMovie])
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

    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [QueryMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecievePopularMovies(queryMovies)
        }
    }
    
    func didDownloadPopularMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    func didDownloadUpcomingMovies(queryMovies: [QueryMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveUpcomingMovies(queryMovies)
        }
    }
    
    func didDownloadUpcomingMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    func didDownloadTopRatedMovies(queryMovies: [QueryMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.didRecieveTopRatedMovies(queryMovies)
        }
    }
    
    func didDownloadTopRatedMovies(withError error: NetworkError) {
        recieveErrorHandler(error)
    }
    
    func didDownloadNowPlayingMovies(queryMovies: [QueryMovie]) {
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
