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
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieCast(movieID: Int, completion: @escaping (Result<MovieCastAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = GetMovieCastEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = GetMovieRecommendationsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MovieVideosAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "en-US"]
        let endpoint = GetMovieVideosEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET LIST IMPLEMENTATIONS
    func getPopularMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetPopularMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetUpcomingMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTopRatedMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetTopRatedMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = GetNowPlayingMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - Private func
    private func handleRequest<T: APIResponse>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        networkService?.request(endpoint) { (result: Result<T, NetworkError>) in
            completion(result)
        }
    }
}
