//
//  TVSeriesDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - PROGRAMMATIC
    func getTVSeriesDetails(seriesID: Int) async throws -> TVSeriesDetails
    func getTVSeriesCast(seriesID: Int) async throws -> (cast: [Cast], crew: [Cast])
    func getTVSeriesVideos(seriesID: Int) async throws -> [Video]
    func getTVSeriesReviews(seriesID: Int) async throws -> [Review]
    func getTVSeriesRecommendations(seriesID: Int) async throws -> [TVSeries]
    func getTVSeriesAccountStates(seriesID: Int) async throws -> MediaAccountStatesAPIResponse
    func getUserLists() async throws -> [UserList]
    
    // MARK: - USER INITIATED
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int)
    func addOrRemoveInWatchlist(seriesID: Int, adding: Bool)
    func addOrRemoveInFavorites(seriesID: Int, adding: Bool)
    
    // MARK: - RATING
    func rate(seriesID: Int, value: Double)
}

final class TVSeriesDetailsScreenInteractor: TVSeriesDetailsScreenInteractorProtocol {
    
    weak var presenter: TVSeriesDetailsScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getTVSeriesDetails(seriesID: Int) async throws -> TVSeriesDetails {
        try await networkService.series.getDetails(seriesID: seriesID)
    }
    
    func getTVSeriesCast(seriesID: Int) async throws -> (cast: [Cast], crew: [Cast]) {
        let result = try await networkService.series.getCast(seriesID: seriesID)
        return (result.cast, result.crew)
    }
    
    func getTVSeriesVideos(seriesID: Int) async throws -> [Video] {
        try await networkService.series.getVideos(seriesID: seriesID).results
    }
    
    func getTVSeriesReviews(seriesID: Int) async throws -> [Review] {
        try await networkService.series.getReviews(seriesID: seriesID).results
    }
    
    func getTVSeriesRecommendations(seriesID: Int) async throws -> [TVSeries] {
        try await networkService.series.getRecommendations(seriesID: seriesID)
    }

    func getTVSeriesAccountStates(seriesID: Int) async throws -> MediaAccountStatesAPIResponse {
        try await networkService.series.getAccountState(seriesID: seriesID)
    }
    
    func getUserLists() async throws -> [UserList] {
        try await networkService.userList.getUserLists(page: 1)
    }
    
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int) {
        Task {
            do {
                let details = try await networkService.series.getSeasonDetails(seriesID: seriesID, seasonNumber: seasonNumber)
                await MainActor.run {
                    self.presenter?.didGetTVSeasonDetails(details)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error)
                }
            }
        }
    }
    
    
    func addOrRemoveInWatchlist(seriesID: Int, adding: Bool) {
        Task {
            do {
                let result = adding ?
                try await networkService.accountList.addMediaInAccountList(mediaID: seriesID, listType: .watchlist, mediaType: .tvShow):
                try await networkService.accountList.removeMediaInAccountList(mediaID: seriesID, listType: .watchlist, mediaType: .tvShow)
                await MainActor.run {
                    self.presenter?.didAddOrRemoveFromWatchlist(message: result.statusMessage)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error)
                }
            }
        }
    }
    
    func addOrRemoveInFavorites(seriesID: Int, adding: Bool) {
        Task {
            do {
                let result = adding ?
                try await networkService.accountList.addMediaInAccountList(mediaID: seriesID, listType: .favorite, mediaType: .tvShow) :
                try await networkService.accountList.removeMediaInAccountList(mediaID: seriesID, listType: .favorite, mediaType: .tvShow)
                await MainActor.run {
                    self.presenter?.didAddOrRemoveFromFavorites(message: result.statusMessage)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error)
                }
            }
        }
    }
    
    // MARK: - RATING
    func rate(seriesID: Int, value: Double) {
        Task {
            do {
                let response = try await networkService.series.rate(seriesID: seriesID, value: value)
                self.presenter?.didRate(message: response.statusMessage, value: value)
            } catch {
                presenter?.didRecieveError(error)
            }
        }
    }
}
