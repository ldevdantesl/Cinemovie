//
//  HomeScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

import UIKit

protocol HomeScreenInteractorProtocol: AnyObject {
    func downloadPopularMovies()
}

final class HomeScreenInteractor: HomeScreenInteractorProtocol {
    weak var presenter: HomeScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func downloadPopularMovies() {
        tmdbService?.getPopularMovies { [weak self] result in
            switch result {
            case .success(let response): self?.presenter?.didDownloadPopularMovies(queryMovies: response.movies)
            case .failure(let error): self?.presenter?.didDownloadPopularMovies(withError: error)
            }
        }
    }
}
