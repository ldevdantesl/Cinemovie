//
//  WatchlistDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 3.05.2025
//

import UIKit

protocol AccountListDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - INITIAL
    func getInitialListMovies(listType: AccountListTypes)
    func getInitialListSeries(listType: AccountListTypes)
    
    // MARK: - PAGINATION
    func getNewPaginatedMoviesForPage(listType: AccountListTypes, page: Int)
    func getNewPaginatedSeriesForPage(listType: AccountListTypes, page: Int)
    
    // MARK: - REFRESHING
    func getRefreshingListMovies(listType: AccountListTypes)
    func getRefreshingListSeries(listType: AccountListTypes)
}

final class AccountListDetailsScreenInteractor: AccountListDetailsScreenInteractorProtocol {
    weak var presenter: AccountListDetailsScreenPresenterProtocol?
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - ACCOUNT INITIAL
    func getInitialListMovies(listType: AccountListTypes) {
        Task {
            do {
                let result: [Movie] = try await networkService.accountList.getMedia(mediaType: .movie, listType: listType, page: 1)
                self.presenter?.didReceiveMedia(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getInitialListSeries(listType: AccountListTypes) {
        Task {
            do {
                let result:[TVSeries] = try await networkService.accountList.getMedia(mediaType: .tvShow, listType: listType, page: 1)
                self.presenter?.didReceiveMedia(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    // MARK: - ACCOUNT PAGINATED
    func getNewPaginatedMoviesForPage(listType: AccountListTypes, page: Int) {
        Task {
            do {
                let result: [Movie] = try await networkService.accountList.getMedia(mediaType: .movie, listType: listType, page: page)
                self.presenter?.didReceiveNewMedia(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getNewPaginatedSeriesForPage(listType: AccountListTypes, page: Int) {
        Task {
            do {
                let result:[TVSeries] = try await networkService.accountList.getMedia(mediaType: .tvShow, listType: listType, page: page)
                self.presenter?.didReceiveMedia(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    // MARK: - ACCOUNT REFRESHING
    func getRefreshingListMovies(listType: AccountListTypes) {
        Task {
            do {
                let result: [Movie] = try await networkService.accountList.getMedia(mediaType: .movie, listType: listType, page: 1)
                self.presenter?.didReceiveMedia(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getRefreshingListSeries(listType: AccountListTypes) {
        Task {
            do {
                let result:[TVSeries] = try await networkService.accountList.getMedia(mediaType: .tvShow, listType: listType, page: 1)
                self.presenter?.didReceiveMedia(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
}
