//
//  TVSeriesDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenInteractorProtocol: AnyObject {
    func getTVSeriesDetails(seriesID: Int)
    func getTVSeriesCast(seriesID: Int)
    func getTVSeriesVideos(seriesID: Int)
    func getTVSeriesReviews(seriesID: Int)
    func getTVSeriesRecommendations(seriesID: Int)
    func getTVSeriesSimilar(seriesID: Int)
}

final class TVSeriesDetailsScreenInteractor: TVSeriesDetailsScreenInteractorProtocol {
    weak var presenter: TVSeriesDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func getTVSeriesDetails(seriesID: Int) {
        tmdbService?.getTVSeriesDetails(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetTVSeriesDetails(success)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesReviews(seriesID: Int) {
        tmdbService?.getTVSeriesReviews(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetTVSeriesReviews(success.results)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesSimilar(seriesID: Int) {
        tmdbService?.getTVSeriesSimilars(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetTVSeriesSimilar(success.results)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesRecommendations(seriesID: Int) {
        tmdbService?.getTVSeriesRecommendations(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetTVSeriesRecommends(success.results)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesCast(seriesID: Int) {
        tmdbService?.getTVSeriesCast(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetTVSeriesCast(success.cast)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesVideos(seriesID: Int) {
        tmdbService?.getTVSeriesVideos(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetTVSeriesVideos(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
}
