//
//  HomeScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol DiscoverScreenInteractorProtocol: AnyObject {
    func fetchMovieList(listType: MovieListType) async throws -> [Movie]
    func fetchTVSeriesList(listType: TVSeriesListType) async throws -> [TVSeries]
    func fetchTrendingPeople(timeWindow: TrendingTimeWindow) async throws -> [Person]
}

final class DiscoverScreenInteractor: DiscoverScreenInteractorProtocol {
    weak var presenter: DiscoverScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchMovieList(listType: MovieListType) async throws -> [Movie] {
        try await networkService.movies.getMovieList(listType: listType)
    }

    func fetchTVSeriesList(listType: TVSeriesListType) async throws -> [TVSeries] {
        try await networkService.series.getList(listType: listType)
    }

    func fetchTrendingPeople(timeWindow: TrendingTimeWindow) async throws -> [Person] {
        try await networkService.person.trending(timeWindow: timeWindow)
    }
}
