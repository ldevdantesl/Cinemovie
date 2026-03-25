//
//  HomeScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol DiscoverScreenInteractorProtocol: AnyObject {
    // MARK: - MOVIES
    func downloadMovieList(listType: MovieListType)
    
    // MARK: - TV SERIES
    func downloadTVSeriesList(listType: TVSeriesListType)
    
    // MARK: - TRENDING
    func downloadTrendingPeople(timeWindow: TrendingTimeWindow)
}

final class DiscoverScreenInteractor: DiscoverScreenInteractorProtocol {
    weak var presenter: DiscoverScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - MOVIES
    func downloadMovieList(listType: MovieListType) {
        Task {
            do {
                let result = try await networkService.movies.getMovieList(listType: listType)
                self.presenter?.didDownloadMovieList(listType: listType, queryMovies: result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    // MARK: - TV SERIES
    func downloadTVSeriesList(listType: TVSeriesListType) {
        Task {
            do {
                let result = try await networkService.series.getList(listType: listType)
                self.presenter?.didDownloadSeriesList(listType: listType, querySeries: result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    // MARK: - TRENDING
    func downloadTrendingPeople(timeWindow: TrendingTimeWindow) {
        Task {
            do {
                let result = try await networkService.person.trending(timeWindow: timeWindow)
                self.presenter?.didDownloadTrendingPeople(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
}
