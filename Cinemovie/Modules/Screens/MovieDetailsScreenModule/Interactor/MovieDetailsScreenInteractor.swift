//
//  MovieDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

protocol MovieDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - PROGRAMMATIC
    func getMovieDetails(movieID: Int) async throws -> MovieDetails
    func getMovieCast(movieID: Int) async throws -> (cast: [Cast], crew: [Cast])
    func getMovieRecommendations(movieID: Int) async throws -> [Movie]
    func getMovieVideos(movieID: Int) async throws -> [Video]
    func getMovieReviews(movieID: Int) async throws -> [Review]
    func getBelongsToCollectionDetails(collectionID: Int) async throws -> BelongsToCollectionDetails
    func getMovieAccountStates(movieID: Int) async throws -> MediaAccountStatesAPIResponse
    func getUserLists() async throws -> [UserList]
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(movieID: Int, adding: Bool)
    func addOrRemoveInFavorites(movieID: Int, adding: Bool)
    
    // MARK: - RATING
    func rateMovie(movieID: Int, value: Double)
    func removeRating(movieID: Int)
}

final class MovieDetailsScreenInteractor: MovieDetailsScreenInteractorProtocol {
    weak var presenter: MovieDetailsScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - PROGRAMMATIC
    func getMovieDetails(movieID: Int) async throws -> MovieDetails {
        try await networkService.movies.getMovieDetails(movieID: movieID)
    }
    
    func getMovieCast(movieID: Int) async throws -> (cast: [Cast], crew: [Cast]) {
        let result = try await networkService.movies.getMovieCast(movieID: movieID)
        return (result.cast, result.crew)
    }
    
    func getMovieRecommendations(movieID: Int) async throws -> [Movie] {
        try await networkService.movies.getMovieRecommendations(movieID: movieID)
    }
    
    func getMovieVideos(movieID: Int) async throws -> [Video] {
        try await networkService.movies.getMovieVideos(movieID: movieID)
    }
    
    func getMovieReviews(movieID: Int) async throws -> [Review] {
        try await networkService.movies.getMovieReviews(movieID: movieID)
    }
    
    func getBelongsToCollectionDetails(collectionID: Int) async throws -> BelongsToCollectionDetails {
        try await networkService.other.collectionDetails(collectionID: collectionID)
    }
    
    func getMovieAccountStates(movieID: Int) async throws -> MediaAccountStatesAPIResponse {
        try await networkService.movies.getMovieAccountState(movieID: movieID)
    }
    
    func getUserLists() async throws -> [UserList] {
        try await networkService.userList.getUserLists(page: 1)
    }
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(movieID: Int, adding: Bool) {
        Task {
            do {
                let result = try await adding ?
                    networkService.accountList.addMediaInAccountList(mediaID: movieID, listType: .watchlist, mediaType: .movie) :
                    networkService.accountList.removeMediaInAccountList(mediaID: movieID, listType: .watchlist, mediaType: .movie)
                await MainActor.run {
                    self.presenter?.didAddToWatchlist(result.statusMessage ?? "")
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
                }
            }
        }
    }
    
    func addOrRemoveInFavorites(movieID: Int, adding: Bool) {
        Task {
            do {
                let result = try await adding ?
                    networkService.accountList.addMediaInAccountList(mediaID: movieID, listType: .favorite, mediaType: .movie) :
                    networkService.accountList.removeMediaInAccountList(mediaID: movieID, listType: .favorite, mediaType: .movie)
                await MainActor.run {
                    self.presenter?.didAddToFavorite(result.statusMessage ?? "")
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
                }
            }
        }
    }
    
    // MARK: - RATING
    func rateMovie(movieID: Int, value: Double) {
        Task {
            do {
                let response = try await networkService.movies.rate(movieID: movieID, value: value)
                await MainActor.run {
                    self.presenter?.didRate(message: response.statusMessage, value: value)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
                }
            }
        }
    }
    
    func removeRating(movieID: Int) {
        Task {
            do {
                let response = try await networkService.movies.removeRating(movieID: movieID)
                await MainActor.run {
                    self.presenter?.didRemovedRating(message: response.statusMessage)
                }
            } catch {
                await MainActor.run {
                    self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
                }
            }
        }
    }
}
