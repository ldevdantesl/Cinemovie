//
//  MovieDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

protocol MovieDetailsScreenInteractorProtocol: AnyObject {
    func getMovieDetails()
}

final class MovieDetailsScreenInteractor: MovieDetailsScreenInteractorProtocol {
    weak var presenter: MovieDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    private let movieID: Int
    
    init(movieID: Int, tmdbService: TMDBService?) {
        self.movieID = movieID
        self.tmdbService = tmdbService
    }
    
    func getMovieDetails() {
        tmdbService?.getMovieDetails(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success): self.presenter?.didGetMovieDetails(success)
            case .failure(let failure): self.presenter?.didRecieveError(failure.localizedDescription)
            }
        }
    }
}
