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
    
    func getMovieAccountStates(movieID: Int, completion: @escaping (Result<MediaAccountStates, NetworkError>) -> Void) {
        guard let sessionID = accountStore.sessionID else { completion(.success(.empty)); return }
        let endpoint = TMDBEndpoints.getMovieAccountStateEndpoint(movieID: movieID, sessionID: sessionID)
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
    
    func getTVSeriesAccountStates(seriesID: Int, completion: @escaping (Result<MediaAccountStates, NetworkError>) -> Void) {
        guard let sessionID = accountStore.sessionID else { completion(.success(.empty)); return }
        let endpoint = TMDBEndpoints.getTVSeriesAccountStateEndpoint(seriesID: seriesID, sessionID: sessionID)
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
    func getMovieSearchResults(query: String, untilPage: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        fetchMoviesSearchResultsRecursively(query: query, untilPage: untilPage, extraParams: queryParams, completion: completion)
    }
    
    func getTVSeriesSearchResults(query: String, untilPage: Int, completion: @escaping (Result<[TVSeries], NetworkError>) -> Void) {
        fetchSeriesSearchResultsRecursively(query: query, untilPage: untilPage, extraParams: queryParams, completion: completion)
    }
    
    // MARK: - ACCOUNT LIST
    func getMoviesInAccountList(listType: AccountListTypes, page: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let accessToken = accountStore.accessToken else { completion(.success(.empty)); return }
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint = TMDBEndpoints.getAccountListMediaEndpoint(accountID: accountID, accessToken: accessToken, mediaType: .movie, accountListType: listType, extraParams: newParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getSeriesInAccountList(listType: AccountListTypes, page: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let accessToken = accountStore.accessToken else { completion(.success(.empty)); return }
        var newParams = queryParams
        newParams["page"] = page.description
        let endpoint = TMDBEndpoints.getAccountListMediaEndpoint(accountID: accountID, accessToken: accessToken, mediaType: .tvShow, accountListType: listType, extraParams: newParams)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func addOrRemoveMediaInAccountList(mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes, adding: Bool, completion: @escaping (Result<AddToAccountListResponse, NetworkError>) -> Void) {
        guard let accountID = accountStore.accountID, let sessionID = accountStore.sessionID else { completion(.failure(.noData)); return }
        let endpoint = TMDBEndpoints.addOrRemoveMediaInAccountListEndpoint(accountID: accountID, sessionID: sessionID, listType: listType, mediaID: mediaID, mediaType: mediaType, adding: adding)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    // MARK: - USER LIST
    func createUserList(name: String, description: String?, isPublic: Bool, completion: @escaping (Result<CreateUserListResponse, NetworkError>) -> Void) {
        guard let accessToken = accountStore.accessToken else { return }
        let language = userService.userLanguage
        let endpoint = TMDBEndpoints.createUserListEndpoint(name: name, description: description, isPublic: isPublic, language: language, accessToken: accessToken)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getUserListDetails(listID: Int, completion: @escaping (Result<UserListDetails, NetworkError>) -> Void) {
        guard let accessToken = accountStore.accessToken else { return }
        let endpoint = TMDBEndpoints.getUserListDetailsEndpoint(listID: listID, language: userService.userLanguage, page: 1, accessToken: accessToken)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func removeUserList(listID: Int, completion: @escaping (Result<RemoveUserListResponse, NetworkError>) -> Void) {
        guard let accessToken = accountStore.accessToken else { return }
        let endpoint = TMDBEndpoints.deleteUserListEndpoint(listID: listID, accessToken: accessToken)
        handleRequest(endpoint: endpoint, completion: completion)
    }
    
    func getUserLists(completion: @escaping (Result<UserListsResponse, NetworkError>) -> Void) {
        guard let accessToken = accountStore.accessToken, let accountID = accountStore.accountID else { return }
        let endpoint = TMDBEndpoints.getUserListsEndpoint(accountID: accountID, accessToken: accessToken, page: 1)
        handleRequest(endpoint: endpoint, completion: completion)
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
    
    // MARK: - PRIVATE FUNC
    private func handleRequest<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        networkService.request(endpoint) { (result: Result<T, NetworkError>) in
            completion(result)
        }
    }
    
    private func fetchMoviesSearchResultsRecursively(
        query: String, page: Int = 1, untilPage: Int,
        accumulated: [Movie] = [], extraParams: [String : String],
        completion: @escaping (Result<[Movie], NetworkError>) -> Void
    ) {
        var params = extraParams
        params["page"] = "\(page.description)"
        
        let endpoint = TMDBEndpoints.getMovieSearchResultsEndpoint(query: query, extraParams: params)
        
        handleRequest(endpoint: endpoint) { (result: Result<MovieListAPIResponse, NetworkError>) in
            switch result {
            case .success(let success):
                let combined = accumulated + success.movies
                if page < untilPage {
                    self.fetchMoviesSearchResultsRecursively(query: query, page: page + 1, untilPage: untilPage, accumulated: combined, extraParams: extraParams, completion: completion)
                } else {
                    completion(.success(combined))
                }
                
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    private func fetchSeriesSearchResultsRecursively(
        query: String, page: Int = 1, untilPage: Int,
        accumulated: [TVSeries] = [], extraParams: [String : String],
        completion: @escaping (Result<[TVSeries], NetworkError>) -> Void
    ) {
        var params = extraParams
        params["page"] = "\(page.description)"
        
        let endpoint = TMDBEndpoints.getTVSeriesSearchResultsEndpoint(query: query, extraParams: params)
        
        handleRequest(endpoint: endpoint) { (result: Result<TVSeriesListAPIResponse, NetworkError>) in
            switch result {
            case .success(let success):
                let combined = accumulated + success.results
                if page < untilPage {
                    self.fetchSeriesSearchResultsRecursively(query: query, page: page + 1, untilPage: untilPage, accumulated: combined, extraParams: extraParams, completion: completion)
                } else {
                    completion(.success(combined))
                }
                
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
