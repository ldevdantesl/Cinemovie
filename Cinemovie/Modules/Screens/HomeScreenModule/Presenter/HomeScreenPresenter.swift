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

    private var downloadGroup = DispatchGroup()
    private var popularMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var allMovies: [Movie] = []
    
    init(interactor: HomeScreenInteractorProtocol, router: HomeScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomeScreenPresenter: HomeScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        downloadGroup.enter()
        interactor.downloadPopularMovies()
        
        downloadGroup.enter()
        interactor.downloadUpcomingMovies()
        
        downloadGroup.enter()
        interactor.downloadTopRatedMovies()
        
        downloadGroup.enter()
        interactor.downloadNowPlayingMovies()
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.didRecieveAllMovies(
                popularMovies: popularMovies, upcomingMovies: upcomingMovies,
                topRatedMovies: topRatedMovies, nowPlayingMovies: nowPlayingMovies,
                allMovies: allMovies
            )
        }
    }
    
    func didTapMovie(_ movie: Movie) {
        router.navigateToMovieDetails(movieID: movie.id)
    }

    // MARK: - FINISHING
    func didDownloadPopularMovies(queryMovies: [Movie]) {
        self.popularMovies = queryMovies
        allMovies.append(contentsOf: queryMovies)
        downloadGroup.leave()
    }
    
    func didDownloadUpcomingMovies(queryMovies: [Movie]) {
        self.upcomingMovies = queryMovies
        allMovies.append(contentsOf: queryMovies)
        downloadGroup.leave()
    }
    
    func didDownloadTopRatedMovies(queryMovies: [Movie]) {
        self.topRatedMovies = queryMovies
        allMovies.append(contentsOf: queryMovies)
        downloadGroup.leave()
    }
    
    func didDownloadNowPlayingMovies(queryMovies: [Movie]) {
        self.nowPlayingMovies = queryMovies
        allMovies.append(contentsOf: queryMovies)
        downloadGroup.leave()
    }
    
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
