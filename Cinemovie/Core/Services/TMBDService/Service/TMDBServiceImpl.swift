//
//  TMBDServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import UIKit

final class TMDBServiceImpl: TMDBService {
    // MARK: - PROPERTIES
    private let networkService: NetworkService
    private let accountStore: AccountStore
    private let userService: UserService
    private var queryParams: [String: String] = [:]
    
    // MARK: - INIT
    init(accountStore: AccountStore, networkService: NetworkService, userService: UserService) {
        self.networkService = networkService
        self.accountStore = accountStore
        self.userService = userService
        self.queryParams["language"] = userService.userLanguage
    }
    
    // MARK: - MOVIE
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getMovieDetailsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieCast(movieID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getMovieCastEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getMovieRecommendationsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieSimilars(movieID: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getMovieSimilarsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getMovieVideosEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getMovieReviews(movieID: Int, completion: @escaping (Result<MediaReviewsAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getMovieReviewsEndpoint(movieID: movieID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - TV SERIES
    func getTVSeriesDetails(seriesID: Int, completion: @escaping (Result<TVSeriesDetails, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeriesDetailsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesCast(seriesID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeriesCastEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesVideos(seriesID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeriesVideosEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesReviews(seriesID: Int, completion: @escaping (Result<MediaReviewsAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeriesReviewsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesSimilars(seriesID: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeriesSimilarsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesRecommendations(seriesID: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeriesRecommendsEndpoint(seriesID: seriesID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - TV SEASON
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int, completion: @escaping (Result<TVSeasonDetails, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTVSeasonDetailsEndpoint(seriesID: seriesID, seasonNumber: seasonNumber, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PERSON
    func getPersonID(creditID: String, completion: @escaping (Result<CreditDetailsAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonIDEndpoint(creditID: creditID)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonDetails(personID: Int, completion: @escaping (Result<PersonDetails, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonDetailsEndpoint(personID: personID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonExternalSources(personID: Int, completion: @escaping (Result<ExternalSource, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonExternalSourcesEndpoint(personID: personID)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonMovieCredits(personID: Int, completion: @escaping (Result<PersonMovieCreditAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonMovieCredits(personID: personID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonTVShowCredits(personID: Int, completion: @escaping (Result<PersonTVShowCreditAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonTVShowCredits(personID: personID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTrendingPeople(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<PeopleListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTrendingPeopleEndpoint(for: timeWindow, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPersonImages(personID: Int, completion: @escaping (Result<PersonImages, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getPersonImagesEndpoint(personID: personID)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - SEARCH
    func getMovieSearchResults(query: String, page: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint = TMDBEndpoints.getMovieSearchResultsEndpoint(query: query, extraParams: newParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getPeopleSearchResults(query: String, page: Int, completion: @escaping (Result<PeopleListAPIResponse, NetworkError>) -> Void) {
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint = TMDBEndpoints.getPeopleSearchResultsEndpoint(query: query, extraParams: newParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTVSeriesSearchResults(query: String, page: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint = TMDBEndpoints.getTVSeriesSearchResultsEndpoint(query: query, extraParams: newParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - WATCHLIST
    func getUserListMovies(listType: UserListTypes, page: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.success(.empty)); return }
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint: Endpoint
        switch listType {
        case .watchlist: endpoint = TMDBEndpoints.getWatchlistedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .movie, extraParams: newParams)
        case .favorite: endpoint = TMDBEndpoints.getFavoritedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .movie, extraParams: newParams)
        case .rated: endpoint = TMDBEndpoints.getRatedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .movie, extraParams: newParams)
        default: endpoint = TMDBEndpoints.getWatchlistedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .movie, extraParams: newParams)
        }
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getUserListSeries(listType: UserListTypes, page: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.success(.empty)); return }
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint: Endpoint
        switch listType {
        case .watchlist: endpoint = TMDBEndpoints.getWatchlistedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .tvShow, extraParams: newParams)
        case .favorite: endpoint = TMDBEndpoints.getFavoritedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .tvShow, extraParams: newParams)
        case .rated: endpoint = TMDBEndpoints.getRatedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .tvShow, extraParams: newParams)
        default: endpoint = TMDBEndpoints.getWatchlistedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: .tvShow, extraParams: newParams)
        }
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func addOrRemoveMediaInWatchlist(mediaID: Int, mediaType: MediaTypes, adding: Bool, completion: @escaping (Result<AddToListResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.failure(.noData)); return }
        let endpoint = TMDBEndpoints.addOrRemovieMediaInWatchlistEndpoint(accountID: accountID, sessionID: sessionID, mediaID: mediaID, mediaType: mediaType, adding: adding)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func isMediaWatchlisted(mediaID: Int, mediaType: MediaTypes, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.success(false)); return }
        let endpoint = TMDBEndpoints.getWatchlistedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: mediaType, extraParams: queryParams)
        
        networkService.request(endpoint) { (result: Result<MediaListAPIResponse, NetworkError>) in
            switch result {
            case .success(let success):
                let movieIDS = success.results.map { $0.id }
                completion(.success(movieIDS.contains(mediaID)))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    // MARK: - FAVORITE
    func addOrRemoveMediaInFavorites(mediaID: Int, mediaType: MediaTypes, adding: Bool, completion: @escaping (Result<AddToListResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.failure(.noData)); return }
        let endpoint = TMDBEndpoints.addOrRemoveMediaInFavoritesEndpoint(accountID: accountID, sessionID: sessionID, mediaID: mediaID, mediaType: mediaType, adding: adding)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func isMediaFavorited(mediaID: Int, mediaType: MediaTypes, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.success(false)); return }
        let endpoint = TMDBEndpoints.getFavoritedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: mediaType, extraParams: queryParams)
        
        networkService.request(endpoint) { (result: Result<MediaListAPIResponse, NetworkError>) in
            switch result {
            case .success(let success): completion(.success(success.results.map { $0.id }.contains(mediaID)))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    // MARK: - RATED
    func isMediaRated(mediaID: Int, mediaType: MediaTypes, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.success(false)); return }
        let endpoint = TMDBEndpoints.getRatedMediaEndpoint(accountID: accountID, sessionID: sessionID, mediaType: mediaType, extraParams: queryParams)
        
        networkService.request(endpoint) { (result: Result<MediaListAPIResponse, NetworkError>) in
            switch result {
            case .success(let success): completion(.success(success.results.map { $0.id }.contains(mediaID)))
            case .failure(let failure): completion(.failure(failure))
            }
        }
    }
    
    // MARK: - OTHER
    func getBelongsToCollectionDetails(collectionID: Int, completion: @escaping (Result<BelongsToCollectionDetails, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getBelongsToCollectionDetailsEndpoint(collectionID: collectionID, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET MOVIE LIST IMPLEMENTATIONS
    func getMovieList(listType: MovieListType, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.createMovieListEndpoint(listType: listType, extraParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTrendingMoviesList(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTrendingMoviesEndpoint(for: timeWindow, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - PRESET TV SERIES LIST IMPLEMENTATIONS
    func getTVSeriesList(listType: TVSeriesListType, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.createTVSeriesListEndpoint(listType: listType, extraParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getTrendingTVSeriesList(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        let endpoint = TMDBEndpoints.getTrendingTVSeriesEndpoint(for: timeWindow, queryParams: queryParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - Private func
    private func handleRequest<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        networkService.request(endpoint) { (result: Result<T, NetworkError>) in
            completion(result)
        }
    }
}
