//
//  MovieDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

protocol MovieDetailsScreenInteractorProtocol: AnyObject {
    func getMovieDetails(movieID: Int)
    func getMovieCast(movieID: Int)
    func getMovieSimilars(movieID: Int)
    func getMovieVideos(movieID: Int)
    func getMovieReviews(movieID: Int)
    func getBelongsToCollectionDetails(collectionID: Int)
}

final class MovieDetailsScreenInteractor: MovieDetailsScreenInteractorProtocol {
    weak var presenter: MovieDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func getMovieDetails(movieID: Int) {
        tmdbService?.getMovieDetails(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieDetails(success)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
    
    func getMovieCast(movieID: Int) {
        tmdbService?.getMovieCast(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieCast(cast: success.cast, crew: success.crew)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
    
    func getMovieSimilars(movieID: Int) {
        tmdbService?.getMovieRecommendations(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieSimilars(queryMovies: success.movies)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
    
    func getMovieVideos(movieID: Int) {
        tmdbService?.getMovieVideos(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieVideos(videos: success.results)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
    
    func getMovieReviews(movieID: Int) {
        tmdbService?.getMovieReviews(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): presenter?.didGetMovieReviews(success.results, reviewCount: success.totalResults)
            case .failure(let failure): presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
    
    func getBelongsToCollectionDetails(collectionID: Int) {
        tmdbService?.getBelongsToCollectionDetails(collectionID: collectionID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let details): presenter?.didGetMovieBelongsToCollectionDetails(details)
            case .failure(let failure): presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
}
