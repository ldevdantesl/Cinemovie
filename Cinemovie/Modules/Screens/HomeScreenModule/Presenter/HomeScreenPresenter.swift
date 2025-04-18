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
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie])
    
    // MARK: - TV SERIES
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries])
    
    // MARK: - PROPERTIES
    var movieLists: [(listType: MovieListType, movies: [Movie])] { get set }
    var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] { get set }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class HomeScreenPresenter {
    weak var view: HomeScreenViewProtocol?
    var router: HomeScreenRouterProtocol
    var interactor: HomeScreenInteractorProtocol

    private var downloadGroup = DispatchGroup()
    
    // MARK: - MOVIES
    public var movieLists: [(listType: MovieListType, movies: [Movie])] = []
    public var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] = []
    
    init(interactor: HomeScreenInteractorProtocol, router: HomeScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - PRIVATE FUNC
    private func downloadMovieList(listType: MovieListType) {
        downloadGroup.enter()
        interactor.downloadMovieList(listType: listType)
    }
    
    private func downloadSeriesList(listType: TVSeriesListType) {
        downloadGroup.enter()
        interactor.downloadTVSeriesList(listType: listType)
    }
    
    private func storeMovieList(_ listType: MovieListType, _ movies: [Movie]) {
        movieLists.append((listType, movies))
        downloadGroup.leave()
    }
    
    private func storeSeriesList(_ listType: TVSeriesListType, _ series: [TVSeries]) {
        seriesLists.append((listType, series))
        downloadGroup.leave()
    }
}

extension HomeScreenPresenter: HomeScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        let movieListToDownload: [MovieListType] = [
            .popular, .upcoming, .topRated, .nowPlaying,
            .animation, .action, .comedy, .drama,
            .fantasy, .horror, .history, .documentary,
        ]
        
        let seriesListToDownload: [TVSeriesListType] = [
            .popular, .airingToday, .topRated, .onTheAir,
            .actionAdventure, .animation, .comedy, .drama,
            .sciFiFantasy, .crime, .documentary, .kids
        ]
        
        movieListToDownload.forEach { downloadMovieList(listType: $0) }
        seriesListToDownload.forEach { downloadSeriesList(listType: $0) }
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.didRecieveAllData(movieLists: movieLists)
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
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie]) {
        storeMovieList(listType, queryMovies)
    }
    
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries]) {
        storeSeriesList(listType, querySeries)
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
