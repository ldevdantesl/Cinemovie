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
