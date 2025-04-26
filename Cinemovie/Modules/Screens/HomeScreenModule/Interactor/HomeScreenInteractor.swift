//
//  HomeScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenInteractorProtocol: AnyObject {
    // MARK: - MOVIES
    func downloadMovieList(listType: MovieListType)
    
    // MARK: - TV SERIES
    func downloadTVSeriesList(listType: TVSeriesListType)
    
    // MARK: - TRENDING
    func downloadTrendingPeople(timeWindow: TrendingTimeWindow)
    
    // MARK: - SEARCH
    func downloadSearchResultsForMovies(query: String)
    func downloadSearchResultsForTVSeries(query: String)
    func downloadSearchResultsForPeople(query: String)
}

final class HomeScreenInteractor: HomeScreenInteractorProtocol {
    weak var presenter: HomeScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - MOVIES
    func downloadMovieList(listType: MovieListType) {
        tmdbService?.getMovieList(listType: listType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadMovieList(listType: listType, queryMovies: success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - TV SERIES
    func downloadTVSeriesList(listType: TVSeriesListType) {
        tmdbService?.getTVSeriesList(listType: listType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadSeriesList(listType: listType, querySeries: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - TRENDING
    func downloadTrendingPeople(timeWindow: TrendingTimeWindow) {
        tmdbService?.getTrendingPeople(for: timeWindow) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didDownloadTrendingPeople(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - SEARCH
    func downloadSearchResultsForMovies(query: String) {
        tmdbService?.getMovieSearchResults(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecieveMovieSearchResults(success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadSearchResultsForPeople(query: String) {
        tmdbService?.getPeopleSearchResults(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecievePeopleSearchResults(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func downloadSearchResultsForTVSeries(query: String) {
        tmdbService?.getTVSeriesSearchResults(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didRecieveTVSeriesSearchResults(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
