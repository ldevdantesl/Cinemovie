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
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getTVSeriesDetails(seriesID: Int) {
        Task {
            do {
                let result = try await networkService.series.getDetails(seriesID: seriesID)
                self.presenter?.didGetTVSeriesDetails(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getTVSeriesReviews(seriesID: Int) {
        Task {
            do {
                let result = try await networkService.series.getReviews(seriesID: seriesID)
                self.presenter?.didGetTVSeriesReviews(result.results)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getTVSeriesRecommendations(seriesID: Int) {
        Task {
            do {
                let result = try await networkService.series.getRecommendations(seriesID: seriesID)
                self.presenter?.didGetTVSeriesRecommends(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getTVSeriesCast(seriesID: Int) {
        Task {
            do {
                let result = try await networkService.series.getCast(seriesID: seriesID)
                self.presenter?.didGetTVSeriesCast(result.cast, crew: result.crew)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getTVSeriesVideos(seriesID: Int) {
        Task {
            do {
                let result = try await networkService.series.getVideos(seriesID: seriesID)
                self.presenter?.didGetTVSeriesVideos(result.results)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int) {
        Task {
            do {
                let result = try await networkService.series.getSeasonDetails(seriesID: seriesID, seasonNumber: seasonNumber)
                self.presenter?.didGetTVSeasonDetails(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getTVSeriesAccountStates(seriesID: Int) {
        Task {
            do {
                let result = try await networkService.series.getAccountState(seriesID: seriesID)
                self.presenter?.didGetTVSeriesAccountStates(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getUserLists() {
        Task {
            do {
                let result = try await networkService.userList.getUserLists(page: 1)
                self.presenter?.didGetUserLists(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    // MARK: - USER INITIATED
    func addOrRemoveInFavorites(seriesID: Int, adding: Bool) {
        Task {
            do {
                let result = try await adding ?
                networkService.accountList.addMediaInAccountList(mediaID: seriesID, listType: .favorite, mediaType: .tvShow) :
                networkService.accountList.removeMediaInAccountList(mediaID: seriesID, listType: .favorite, mediaType: .tvShow)
                self.presenter?.didAddOrRemoveFromFavorites(message: result.statusMessage ?? "")
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func addOrRemoveInWatchlist(seriesID: Int, adding: Bool) {
        Task {
            do {
                let result = try await adding ?
                networkService.accountList.addMediaInAccountList(mediaID: seriesID, listType: .watchlist, mediaType: .tvShow) :
                networkService.accountList.removeMediaInAccountList(mediaID: seriesID, listType: .watchlist, mediaType: .tvShow)
                self.presenter?.didAddOrRemoveFromWatchlist(message: result.statusMessage ?? "")
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
}
