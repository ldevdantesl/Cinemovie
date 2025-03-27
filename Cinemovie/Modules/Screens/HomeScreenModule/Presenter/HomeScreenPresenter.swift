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
    func didTapMedia(_ media: Media)
    
    // MARK: - MOVIES
    func didDownloadPopularMovies(queryMovies: [Movie])
    func didDownloadUpcomingMovies(queryMovies: [Movie])
    func didDownloadTopRatedMovies(queryMovies: [Movie])
    func didDownloadNowPlayingMovies(queryMovies: [Movie])
    
    // MARK: - TV SERIES
    func didDownloadPopularTVSeries(querySeries: [TVSeries])
    func didDownloadAiringTodayTVSeries(querySeries: [TVSeries])
    func didDownloadTopRatedTVSeries(querySeries: [TVSeries])
    func didDownloadOnTheAirTVSeries(querySeries: [TVSeries])
    
    // MARK: - PROPERTIES
    var popularMovies: [Movie] { get }
    var upcomingMovies: [Movie] { get }
    var topRatedMovies: [Movie] { get }
    var nowPlayingMovies: [Movie] { get }
    var allMovies: [Movie] { get }
    
    var popularTVSeries: [TVSeries] { get }
    var onTheAirTVSeries: [TVSeries] { get }
    var topRatedTVSeries: [TVSeries] { get }
    var airingTodayTVSeries: [TVSeries] { get }
    var allTVSeries: [TVSeries] { get }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class HomeScreenPresenter {
    weak var view: HomeScreenViewProtocol?
    var router: HomeScreenRouterProtocol
    var interactor: HomeScreenInteractorProtocol

    private var downloadGroup = DispatchGroup()
    
    // MARK: - MOVIES
    public var popularMovies: [Movie] = []
    public var upcomingMovies: [Movie] = []
    public var topRatedMovies: [Movie] = []
    public var nowPlayingMovies: [Movie] = []
    public var allMovies: [Movie] = []
    
    // MARK: - TVSeries
    public var popularTVSeries: [TVSeries] = []
    public var onTheAirTVSeries: [TVSeries] = []
    public var topRatedTVSeries: [TVSeries] = []
    public var airingTodayTVSeries: [TVSeries] = []
    public var allTVSeries: [TVSeries] = []
    
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
        
        downloadGroup.enter()
        interactor.downloadPopularTVSeries()
        
        downloadGroup.enter()
        interactor.downloadTopRatedTVSeries()
        
        downloadGroup.enter()
        interactor.downloadAiringTodayTVSeries()
        
        downloadGroup.enter()
        interactor.downloadOnTheAirTVSeries()
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.didRecieveAllMovies(
                popularMovies: popularMovies, upcomingMovies: upcomingMovies,
                topRatedMovies: topRatedMovies, nowPlayingMovies: nowPlayingMovies,
                allMovies: allMovies
            )
        }
    }
    
    func didTapMedia(_ media: any Media) {
        switch media {
        case is Movie: router.navigateToMovieDetails(movieID: media.id)
        case is TVSeries: router.navigateToTVSeriesDetails(seriesID: media.id)
        default: fatalError("Media not supported")
        }
    }

    // MARK: - MOVIES
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
    
    // MARK: - TV SERIES
    func didDownloadPopularTVSeries(querySeries: [TVSeries]) {
        self.popularTVSeries = querySeries
        allTVSeries.append(contentsOf: querySeries)
        downloadGroup.leave()
    }
    
    func didDownloadTopRatedTVSeries(querySeries: [TVSeries]) {
        self.topRatedTVSeries = querySeries
        allTVSeries.append(contentsOf: querySeries)
        downloadGroup.leave()
    }
    
    func didDownloadAiringTodayTVSeries(querySeries: [TVSeries]) {
        self.airingTodayTVSeries = querySeries
        allTVSeries.append(contentsOf: querySeries)
        downloadGroup.leave()
    }
    
    func didDownloadOnTheAirTVSeries(querySeries: [TVSeries]) {
        self.onTheAirTVSeries = querySeries
        allTVSeries.append(contentsOf: querySeries)
        downloadGroup.leave()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
