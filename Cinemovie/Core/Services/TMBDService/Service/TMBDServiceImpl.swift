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
    
    // MARK: - MOVIE
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieDetailsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieCast(movieID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieCastEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieRecommendationsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieSimilars(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieSimilarsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieVideosEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieReviews(movieID: Int, completion: @escaping (Result<MovieReviewsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "en-US"]
        let endpoint = TMDBEndpoints.getMovieReviewsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - TV SERIES
    func getTVSeriesDetails(seriesID: Int, completion: @escaping (Result<TVSeriesDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTVSeriesDetailsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesCast(seriesID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTVSeriesCastEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesVideos(seriesID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTVSeriesVideosEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PERSON
    func getPersonID(creditID: String, completion: @escaping (Result<CreditDetailsAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonIDEndpoint(creditID: creditID)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonDetails(personID: Int, completion: @escaping (Result<PersonDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getPersonDetailsEndpoint(personID: personID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonExternalSources(personID: Int, completion: @escaping (Result<ExternalSource, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonExternalSourcesEndpoint(personID: personID)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonMovieCredits(personID: Int, completion: @escaping (Result<PersonMovieCreditAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getPersonMovieCredits(personID: personID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonTVShowCredits(personID: Int, completion: @escaping (Result<PersonTVShowCreditAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getPersonTVShowCredits(personID: personID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - OTHER
    func getBelongsToCollectionDetails(collectionID: Int, completion: @escaping (Result<BelongsToCollectionDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getBelongsToCollectionDetailsEndpoint(collectionID: collectionID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET MOVIE LIST IMPLEMENTATIONS
    func getPopularMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = TMDBEndpoints.getPopularMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = TMDBEndpoints.getUpcomingMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTopRatedMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = TMDBEndpoints.getTopRatedMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : "1"]
        let endpoint = TMDBEndpoints.getNowPlayingMoviesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET TV SERIES LIST IMPLEMENTATIONS
    func getPopularTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getPopularTVSeriesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTopRatedTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTopRatedTVSeriesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getAiringTodayTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getAiringTodayTVSeriesEndpoint(queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getOnTheAirTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getOnTheAirTVSeriesEndpoint(queryParams: queryParams)
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
