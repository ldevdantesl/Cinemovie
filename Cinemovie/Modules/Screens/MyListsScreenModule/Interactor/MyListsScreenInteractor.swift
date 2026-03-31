//
//  WatchlistScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 22.04.2025
//

import UIKit

protocol MyListsScreenInteractorProtocol: AnyObject {
    func getWatchlistMovies() async throws -> [Movie]
    func getWatchlistTVSeries() async throws -> [TVSeries]
    func getFavoriteMovies() async throws -> [Movie]
    func getFavoriteTVSeries() async throws -> [TVSeries]
    func getRatedMovies() async throws -> [Movie]
    func getRatedTVSeries() async throws -> [TVSeries]
    func getUserLists() async throws -> [UserList]
    func getUserListDetails(list: UserList) async throws -> UserListDetails
    func createNewList(listName: String, listDescription: String?, isPublic: Bool) async throws
    func removeUserList(list: UserListDetails) async throws
}

final class MyListsScreenInteractor: MyListsScreenInteractorProtocol {
    weak var presenter: MyListsScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - WATCHLIST
    func getWatchlistMovies() async throws -> [Movie] {
        try await networkService.accountList.getMedia(mediaType: .movie, listType: .watchlist, page: 1)
    }

    func getWatchlistTVSeries() async throws -> [TVSeries] {
        try await networkService.accountList.getMedia(mediaType: .tvShow, listType: .watchlist, page: 1)
    }

    // MARK: - FAVORITE
    func getFavoriteMovies() async throws -> [Movie] {
        try await networkService.accountList.getMedia(mediaType: .movie, listType: .favorite, page: 1)
    }

    func getFavoriteTVSeries() async throws -> [TVSeries] {
        try await networkService.accountList.getMedia(mediaType: .tvShow, listType: .favorite, page: 1)
    }

    // MARK: - RATED
    func getRatedMovies() async throws -> [Movie] {
        try await networkService.accountList.getMedia(mediaType: .movie, listType: .rated, page: 1)
    }

    func getRatedTVSeries() async throws -> [TVSeries] {
        try await networkService.accountList.getMedia(mediaType: .tvShow, listType: .rated, page: 1)
    }

    // MARK: - USER LIST
    func getUserLists() async throws -> [UserList] {
        try await networkService.userList.getUserLists(page: 1)
    }

    func getUserListDetails(list: UserList) async throws -> UserListDetails {
        try await networkService.userList.getUserListDetails(listID: list.id, page: 1)
    }

    func createNewList(listName: String, listDescription: String?, isPublic: Bool) async throws {
        try await networkService.userList.createUserList(name: listName, description: listDescription, isPublic: isPublic)
    }

    func removeUserList(list: UserListDetails) async throws {
        try await networkService.userList.removeUserList(listID: list.id)
    }
}
