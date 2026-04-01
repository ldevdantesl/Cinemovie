//
//  MovieDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

protocol MovieDetailsScreenInteractorProtocol: AnyObject {
    // MARK: - PROGRAMMATIC
    func getMovieDetails(movieID: Int)
    func getMovieCast(movieID: Int)
    func getMovieRecommendations(movieID: Int)
    func getMovieVideos(movieID: Int)
    func getMovieReviews(movieID: Int)
    func getBelongsToCollectionDetails(collectionID: Int)
    func getMovieAccountStates(movieID: Int)
    func getUserLists()
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(movieID: Int, adding: Bool)
    func addOrRemoveInFavorites(movieID: Int, adding: Bool)
}

final class MovieDetailsScreenInteractor: MovieDetailsScreenInteractorProtocol {
    weak var presenter: MovieDetailsScreenPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - PROGRAMMATIC
    func getMovieDetails(movieID: Int) {
        Task {
            do {
                let result = try await networkService.movies.getMovieDetails(movieID: movieID)
                self.presenter?.didGetMovieDetails(result)
            } catch {
                self.presenter?.didRecieveError(error.localizedDescription, goesBack: true)
            }
        }
    }
    
    func getMovieCast(movieID: Int) {
        Task {
            do {
                let result = try await networkService.movies.getMovieCast(movieID: movieID)
                self.presenter?.didGetMovieCast(cast: result.cast, crew: result.crew)
            } catch {
                self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func getMovieRecommendations(movieID: Int) {
        Task {
            do {
                let result = try await networkService.movies.getMovieRecommendations(movieID: movieID)
                self.presenter?.didGetMovieRecommendations(queryMovies: result)
            } catch {
                self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func getMovieVideos(movieID: Int) {
        Task {
            do {
                let result = try await networkService.movies.getMovieVideos(movieID: movieID)
                self.presenter?.didGetMovieVideos(videos: result)
            } catch {
                self.presenter?.didGetMovieVideos(videos: [])
            }
        }
    }
    
    func getMovieReviews(movieID: Int) {
        Task {
            do {
                let result = try await networkService.movies.getMovieReviews(movieID: movieID)
                self.presenter?.didGetMovieReviews(result)
            } catch {
                self.presenter?.didGetMovieReviews([])
            }
        }
    }
    
    func getBelongsToCollectionDetails(collectionID: Int) {
        Task {
            do {
                let result = try await networkService.other.collectionDetails(collectionID: collectionID)
                self.presenter?.didGetMovieBelongsToCollectionDetails(result)
            } catch {
                presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func getMovieAccountStates(movieID: Int) {
        Task {
            do {
                let result = try await networkService.movies.getMovieAccountState(movieID: movieID)
                self.presenter?.didGetMovieAccountStates(result)
            } catch {
                presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func getUserLists() {
        Task {
            do {
                let result = try await networkService.userList.getUserLists(page: 1)
                self.presenter?.didGetUserLists(result)
            } catch {
                self.presenter?.didGetUserLists([])
            }
        }
    }
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(movieID: Int, adding: Bool) {
        Task {
            do {
                let result = try await adding ?
                networkService.accountList.addMediaInAccountList(mediaID: movieID, listType: .watchlist, mediaType: .movie) :
                networkService.accountList.removeMediaInAccountList(mediaID: movieID, listType: .watchlist, mediaType: .movie)
                self.presenter?.didAddToWatchlist(result.statusMessage ?? "")
            } catch {
                presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func addOrRemoveInFavorites(movieID: Int, adding: Bool) {
        Task {
            do {
                let result = try await adding ?
                networkService.accountList.addMediaInAccountList(mediaID: movieID, listType: .favorite, mediaType: .movie) :
                networkService.accountList.removeMediaInAccountList(mediaID: movieID, listType: .favorite, mediaType: .movie)
                self.presenter?.didAddToWatchlist(result.statusMessage ?? "")
            } catch {
                presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
}
