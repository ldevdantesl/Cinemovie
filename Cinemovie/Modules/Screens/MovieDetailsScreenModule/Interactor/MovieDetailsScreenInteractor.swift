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
    
    func findIfFavorited(movieID: Int)
    func findIfWatchlisted(movieID: Int)
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(movieID: Int, adding: Bool)
    func addOrRemoveInFavorites(movieID: Int, adding: Bool)
}

final class MovieDetailsScreenInteractor: MovieDetailsScreenInteractorProtocol {
    weak var presenter: MovieDetailsScreenPresenterProtocol?
    private let tmdbService: TMDBService
    
    init(tmdbService: TMDBService) {
        self.tmdbService = tmdbService
    }
    
    // MARK: - PROGRAMMATIC
    func getMovieDetails(movieID: Int) {
        tmdbService.getMovieDetails(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieDetails(success)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription, goesBack: true)
            }
        }
    }
    
    func getMovieCast(movieID: Int) {
        tmdbService.getMovieCast(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieCast(cast: success.cast, crew: success.crew)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription, goesBack: false)
            }
        }
    }
    
    func getMovieRecommendations(movieID: Int) {
        tmdbService.getMovieRecommendations(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieRecommendations(queryMovies: success.movies)
            case .failure(let error): self.presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func getMovieVideos(movieID: Int) {
        tmdbService.getMovieVideos(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieVideos(videos: success.results)
            case .failure: self.presenter?.didGetMovieVideos(videos: [])
            }
        }
    }
    
    func getMovieReviews(movieID: Int) {
        tmdbService.getMovieReviews(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetMovieReviews(success.results)
            case .failure: presenter?.didGetMovieReviews([])
            }
        }
    }
    
    func getBelongsToCollectionDetails(collectionID: Int) {
        tmdbService.getBelongsToCollectionDetails(collectionID: collectionID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let details): presenter?.didGetMovieBelongsToCollectionDetails(details)
            case .failure(let failure): presenter?.didRecieveError(failure.localizedDescription, goesBack: false)
            }
        }
    }
    
    func findIfFavorited(movieID: Int) {
        tmdbService.isMediaFavorited(mediaID: movieID, mediaType: .movie) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorited): presenter?.isMovieFavorited(favorited)
            case .failure(let error): presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    func findIfWatchlisted(movieID: Int) {
        tmdbService.isMediaWatchlisted(mediaID: movieID, mediaType: .movie) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorited): presenter?.isMovieWatchlisted(favorited)
            case .failure(let error): presenter?.didRecieveError(error.localizedDescription, goesBack: false)
            }
        }
    }
    
    // MARK: - USER INITIATED
    func addOrRemoveInWatchlist(movieID: Int, adding: Bool) {
        tmdbService.addOrRemoveMediaInWatchlist(mediaID: movieID, mediaType: .movie, adding: adding){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didAddToWatchlist(success.statusMessage)
            case .failure(let failure): presenter?.didRecieveError(failure.localizedDescription, goesBack: false)
            }
        }
    }
    
    func addOrRemoveInFavorites(movieID: Int, adding: Bool) {
        tmdbService.addOrRemoveMediaInFavorites(mediaID: movieID, mediaType: .movie, adding: adding) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didAddToFavorite(success.statusMessage)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription, goesBack: false)
            }
        }
    }
}
