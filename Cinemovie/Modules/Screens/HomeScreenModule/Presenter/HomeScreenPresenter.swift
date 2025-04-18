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
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: Media)
    func didTapPerson(_ person: Person)
    
    // MARK: - MOVIES
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie])
    
    // MARK: - TV SERIES
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries])
    
    // MARK: - TRENDING
    func didDownloadTrendingMovies(_ movies: [Movie])
    func didDownloadTrendingSeries(_ series: [TVSeries])
    func didDownloadTrendingPeople(_ people: [Person])
    
    // MARK: - PROPERTIES
    var movieLists: [(listType: MovieListType, movies: [Movie])] { get set }
    var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] { get set }
    var trendingMovies: [Movie] { get set }
    var trendingTVSeries: [TVSeries] { get set }
    var trendingPeople: [Person] { get set }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class HomeScreenPresenter {
    weak var view: HomeScreenViewProtocol?
    var router: HomeScreenRouterProtocol
    var interactor: HomeScreenInteractorProtocol
    
    // MARK: - PROPERTIES
    private var downloadGroup = DispatchGroup()
    
    public var movieLists: [(listType: MovieListType, movies: [Movie])] = []
    public var seriesLists: [(listType: TVSeriesListType, series: [TVSeries])] = []
    
    public var trendingMovies: [Movie] = []
    public var trendingTVSeries: [TVSeries] = []
    public var trendingPeople: [Person] = []
    
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
        
        downloadGroup.enter()
        interactor.downloadTrendingMovies(timeWindow: .day)
        
        downloadGroup.enter()
        interactor.downloadTrendingTVSeries(timeWindow: .day)
        
        downloadGroup.enter()
        interactor.downloadTrendingPeople(timeWindow: .day)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.didRecieveAllData(movieLists: self.movieLists, trendingPeople: self.trendingPeople)
        }
    }
    
    // MARK: - USER INITIATED
    func didTapMedia(_ media: any Media) {
        switch media {
        case is Movie: router.navigateToMovieDetails(movieID: media.id)
        case is TVSeries: router.navigateToTVSeriesDetails(seriesID: media.id)
        default: fatalError("Media not supported")
        }
    }
    
    func didTapPerson(_ person: Person) {
        router.navigateToPersonDetails(personID: person.id)
    }

    // MARK: - MOVIES
    func didDownloadMovieList(listType: MovieListType, queryMovies: [Movie]) {
        storeMovieList(listType, queryMovies)
    }
    
    // MARK: - TV SERIES
    func didDownloadSeriesList(listType: TVSeriesListType, querySeries: [TVSeries]) {
        storeSeriesList(listType, querySeries)
    }
    
    // MARK: - TRENDING
    func didDownloadTrendingMovies(_ movies: [Movie]) {
        self.trendingMovies = movies
        downloadGroup.leave()
    }
    
    func didDownloadTrendingPeople(_ people: [Person]) {
        self.trendingPeople = Array(people.prefix(upTo: 10))
        downloadGroup.leave()
    }
    
    func didDownloadTrendingSeries(_ series: [TVSeries]) {
        self.trendingTVSeries = series
        downloadGroup.leave()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
