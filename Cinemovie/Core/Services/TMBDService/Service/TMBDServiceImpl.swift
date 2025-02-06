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
