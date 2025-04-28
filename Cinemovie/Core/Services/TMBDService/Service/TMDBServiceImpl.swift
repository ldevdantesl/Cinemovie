//
//  TMBDServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import UIKit

final class TMDBServiceImpl: TMDBService {
    // MARK: - PROPERTIES
    weak var networkService: NetworkService?
    
    // MARK: - INIT
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
    
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieRecommendationsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieSimilars(movieID: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieSimilarsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getMovieVideosEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieReviews(movieID: Int, completion: @escaping (Result<MediaReviewsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "en-US", "dummy" : UUID().uuidString]
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
    
    func getTVSeriesReviews(seriesID: Int, completion: @escaping (Result<MediaReviewsAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "en-US"]
        let endpoint = TMDBEndpoints.getTVSeriesReviewsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesSimilars(seriesID: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTVSeriesSimilarsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesRecommendations(seriesID: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTVSeriesRecommendsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - TV SEASON
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int, completion: @escaping (Result<TVSeasonDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTVSeasonDetailsEndpoint(seriesID: seriesID, seasonNumber: seasonNumber, queryParams: queryParams)
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
    
    func getTrendingPeople(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<PeopleListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTrendingPeopleEndpoint(for: timeWindow, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonImages(personID: Int, completion: @escaping (Result<PersonImages, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonImagesEndpoint(personID: personID)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - SEARCH
    func getMovieSearchResults(query: String, page: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : page.description]
        let endpoint = TMDBEndpoints.getMovieSearchResultsEndpoint(query: query, extraParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPeopleSearchResults(query: String, page: Int, completion: @escaping (Result<PeopleListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : page.description]
        let endpoint = TMDBEndpoints.getPeopleSearchResultsEndpoint(query: query, extraParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesSearchResults(query: String, page: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru", "page" : page.description]
        let endpoint = TMDBEndpoints.getTVSeriesSearchResultsEndpoint(query: query, extraParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - OTHER
    func getBelongsToCollectionDetails(collectionID: Int, completion: @escaping (Result<BelongsToCollectionDetails, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getBelongsToCollectionDetailsEndpoint(collectionID: collectionID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET MOVIE LIST IMPLEMENTATIONS
    func getMovieList(listType: MovieListType, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let extraParams = ["language": "ru"]
        let endpoint = TMDBEndpoints.createMovieListEndpoint(listType: listType, extraParams: extraParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTrendingMoviesList(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTrendingMoviesEndpoint(for: timeWindow, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET TV SERIES LIST IMPLEMENTATIONS
    func getTVSeriesList(listType: TVSeriesListType, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let extraParams = ["language": "ru"]
        let endpoint = TMDBEndpoints.createTVSeriesListEndpoint(listType: listType, extraParams: extraParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTrendingTVSeriesList(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let queryParams = ["language" : "ru"]
        let endpoint = TMDBEndpoints.getTrendingTVSeriesEndpoint(for: timeWindow, queryParams: queryParams)
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
