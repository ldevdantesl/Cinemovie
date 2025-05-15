//
//  TVSeriesDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - PROGRAMMATIC
    func getTVSeriesDetails(seriesID: Int)
    func getTVSeriesCast(seriesID: Int)
    func getTVSeriesVideos(seriesID: Int)
    func getTVSeriesReviews(seriesID: Int)
    func getTVSeriesRecommendations(seriesID: Int)
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int)
    func getTVSeriesAccountStates(seriesID: Int)
    func getUserLists()
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(seriesID: Int, adding: Bool)
    func addOrRemoveInFavorites(seriesID: Int, adding: Bool)
}

final class TVSeriesDetailsScreenInteractor: TVSeriesDetailsScreenInteractorProtocol {
    weak var presenter: TVSeriesDetailsScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    func getTVSeriesDetails(seriesID: Int) {
        tmdbService.getTVSeriesDetails(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetTVSeriesDetails(success)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesReviews(seriesID: Int) {
        tmdbService.getTVSeriesReviews(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetTVSeriesReviews(success.results)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesRecommendations(seriesID: Int) {
        tmdbService.getTVSeriesRecommendations(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetTVSeriesRecommends(success.results)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesCast(seriesID: Int) {
        tmdbService.getTVSeriesCast(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetTVSeriesCast(success.cast, crew: success.crew)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesVideos(seriesID: Int) {
        tmdbService.getTVSeriesVideos(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetTVSeriesVideos(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int) {
        tmdbService.getTVSeasonDetails(seriesID: seriesID, seasonNumber: seasonNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let details): self.presenter?.didGetTVSeasonDetails(details)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getTVSeriesAccountStates(seriesID: Int) {
        tmdbService.getTVSeriesAccountStates(seriesID: seriesID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetTVSeriesAccountStates(success)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func getUserLists() {
        tmdbService.getUserLists { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetUserLists(success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure)
            }
        }
    }
    
    // MARK: - USER INITIATED
    func addOrRemoveInFavorites(seriesID: Int, adding: Bool) {
        tmdbService.addOrRemoveMediaInAccountList(mediaID: seriesID, listType: .favorite, mediaType: .tvShow, adding: adding) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didAddOrRemoveFromFavorites(message: success.statusMessage)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
    
    func addOrRemoveInWatchlist(seriesID: Int, adding: Bool) {
        tmdbService.addOrRemoveMediaInAccountList(mediaID: seriesID, listType: .watchlist, mediaType: .tvShow, adding: adding) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didAddOrRemoveFromWatchlist(message: success.statusMessage)
            case .failure(let failure): presenter?.didRecieveError(failure)
            }
        }
    }
}
