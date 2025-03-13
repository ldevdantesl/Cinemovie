//
//  TMBDServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import UIKit

final class TMBDServiceImpl: TMDBService {
    weak var networkService: NetworkService?
    
    init(networkService: NetworkService? = nil) {
        self.networkService = networkService
    }
    
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = GetMovieDetailsEndpoint(movieID: movieID, queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieDetails, NetworkError>) in
            switch result {
            case .success(let details): completion(.success(details))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    func getMovieCast(movieID: Int, completion: @escaping (Result<MovieCastAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = GetMovieCastEndpoint(movieID: movieID, queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieCastAPIResponse, NetworkError>) in
            switch result {
            case .success(let cast): completion(.success(cast))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = GetMovieRecommendationsEndpoint(movieID: movieID, queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieListsAPIResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    // MARK: - PRESET LIST IMPLEMENTATIONS
    func getPopularMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetPopularMoviesEndpoint(queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieListsAPIResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    func getUpcomingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetUpcomingMoviesEndpoint(queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieListsAPIResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    func getTopRatedMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetTopRatedMoviesEndpoint(queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieListsAPIResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetNowPlayingMoviesEndpoint(queryParams: queryParams)
        networkService?.request(endpoint) { (result: Result<MovieListsAPIResponse, NetworkError>) in
            switch result {
            case .success(let response): completion(.success(response))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
}
