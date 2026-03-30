//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenInteractorProtocol: AnyObject {
    // MARK: - WATCHLIST
    func getWatchlistMovies()
    func getWatchlistTVSeries()
    
    // MARK: - FAVORITE
    func getFavoriteMovies()
    func getFavoriteTVSeries()
    
    // MARK: - RATED
    func getRatedMovies()
    func getRatedTVSeries()
    
    // MARK: - USER LIST
    func createNewList(listName: String, listDescription: String?, isPublic: Bool)
    func getUserLists()
    func getUserListDetails(list: UserList)
    func removeUserList(list: UserListDetails)
}

final class MyListsScreenInteractor: MyListsScreenInteractorProtocol {
    weak var presenter: MyListsScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - WATCHLIST
    func getWatchlistMovies() {
        Task {
            do {
                let result: [Movie] = try await networkService.accountList.getMedia(mediaType: .movie, listType: .watchlist, page: 1)
                self.presenter?.didGetWatchlistMovies(result)
            } catch {
                self.presenter?.didGetWatchlistMovies([])
            }
        }
    }
    
    func getWatchlistTVSeries() {
        Task {
            do {
                let result: [TVSeries] = try await networkService.accountList.getMedia(mediaType: .tvShow, listType: .watchlist, page: 1)
                self.presenter?.didGetWatchlistTVSeries(result)
            } catch {
                self.presenter?.didGetWatchlistTVSeries([])
            }
        }
    }
    
    // MARK: - FAVORITE
    func getFavoriteMovies() {
        Task {
            do {
                let result: [Movie] = try await networkService.accountList.getMedia(mediaType: .movie, listType: .favorite, page: 1)
                self.presenter?.didGetFavoriteMovies(result)
            } catch {
                self.presenter?.didGetFavoriteMovies([])
            }
        }
    }
    
    func getFavoriteTVSeries() {
        Task {
            do {
                let result: [TVSeries] = try await networkService.accountList.getMedia(mediaType: .tvShow, listType: .favorite, page: 1)
                self.presenter?.didGetFavoriteTVSeries(result)
            } catch {
                self.presenter?.didGetFavoriteTVSeries([])
            }
        }
    }
    
    // MARK: - RATED
    func getRatedMovies() {
        Task {
            do {
                let result: [Movie] = try await networkService.accountList.getMedia(mediaType: .movie, listType: .rated, page: 1)
                self.presenter?.didGetRatedMovies(result)
            } catch {
                self.presenter?.didGetRatedMovies([])
            }
        }
    }
    
    func getRatedTVSeries() {
        Task {
            do {
                let result: [TVSeries]  = try await networkService.accountList.getMedia(mediaType: .tvShow, listType: .rated, page: 1)
                self.presenter?.didGetRatedTVSeries(result)
            } catch {
                self.presenter?.didGetRatedTVSeries([])
            }
        }
    }
    
    // MARK: - USER LIST
    func createNewList(listName: String, listDescription: String?, isPublic: Bool) {
        Task {
            do {
                try await networkService.userList.createUserList(name: listName, description: listDescription, isPublic: isPublic)
                self.presenter?.didCreateNewList()
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getUserLists() {
        Task {
            do {
                print("📡 Fetching user lists...")
                let result = try await networkService.userList.getUserLists(page: 1)
                print("✅ Got \(result.count) user lists")
                self.presenter?.didReceieveUserLists(lists: result)
            } catch {
                print("❌ getUserLists failed: \(error)")
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func removeUserList(list: UserListDetails) {
        Task {
            do {
                try await networkService.userList.removeUserList(listID: list.id)
                self.presenter?.didRemoveList()
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
    
    func getUserListDetails(list: UserList) {
        Task {
            do {
                let result = try await networkService.userList.getUserListDetails(listID: list.id, page: 1)
                self.presenter?.didReceiveUserListDetails(result)
            } catch {
                self.presenter?.didRecieveError(error)
            }
        }
    }
}
