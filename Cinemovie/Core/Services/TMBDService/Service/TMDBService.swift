//
//  TMDBService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

protocol TMDBService: AnyObject {
    // MARK: - MOVIES
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void)
    func getMovieCast(movieID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void)
    func getMovieSimilars(movieID: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void)
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void)
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void)
    func getMovieReviews(movieID: Int, completion: @escaping (Result<MediaReviewsAPIResponse, NetworkError>) -> Void)
    
    // MARK: - TV SERIES
    func getTVSeriesDetails(seriesID: Int, completion: @escaping (Result<TVSeriesDetails, NetworkError>) -> Void)
    func getTVSeriesCast(seriesID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void)
    func getTVSeriesVideos(seriesID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void)
    func getTVSeriesSimilars(seriesID: Int, completion: @escaping(Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getTVSeriesRecommendations(seriesID: Int, completion: @escaping(Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getTVSeriesReviews(seriesID: Int, completion: @escaping (Result<MediaReviewsAPIResponse, NetworkError>) -> Void)
    
    // MARK: - TV SEASON
    func getTVSeasonDetails(seriesID: Int, seasonNumber: Int, completion: @escaping (Result<TVSeasonDetails, NetworkError>) -> Void)
    
    // MARK: - PERSON
    func getPersonID(creditID: String, completion: @escaping (Result<CreditDetailsAPIResponse, NetworkError>) -> Void)
    func getPersonDetails(personID: Int, completion: @escaping (Result<PersonDetails, NetworkError>) -> Void)
    func getPersonExternalSources(personID: Int, completion: @escaping (Result<ExternalSource, NetworkError>) -> Void)
    func getPersonMovieCredits(personID: Int, completion: @escaping (Result<PersonMovieCreditAPIResponse, NetworkError>) -> Void)
    func getPersonTVShowCredits(personID: Int, completion: @escaping (Result<PersonTVShowCreditAPIResponse, NetworkError>) -> Void)
    func getPersonImages(personID: Int, completion: @escaping (Result<PersonImages, NetworkError>) -> Void)
    
    // MARK: - SEARCH
    func getMovieSearchResults(query: String, untilPage: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void)
    func getTVSeriesSearchResults(query: String, untilPage: Int, completion: @escaping (Result<[TVSeries], NetworkError>) -> Void)
    
    // MARK: - USER LISTS
    func getUserListMovies(listType: UserListTypes, page: Int, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void)
    func getUserListSeries(listType: UserListTypes, page: Int, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getAllUserListMovies(listType: UserListTypes, completion: @escaping (Result<[Movie], NetworkError>) -> Void)
    func getAllUserListSeries(listType: UserListTypes, completion: @escaping (Result<[TVSeries], NetworkError>) -> Void)
    func addOrRemoveMediaInUserList(mediaID: Int, listType: UserListTypes, mediaType: MediaTypes, adding: Bool, completion: @escaping (Result<AddToListResponse, NetworkError>) -> Void)
    
    // MARK: - CUSTOM LISTS
    func createCustomList(name: String, description: String?, isPublic: Bool, completion: @escaping (Result<CreateUserListResponse, NetworkError>) -> Void)
    func getUserCustomLists(completion: @escaping (Result<UserCustomListsResponse, NetworkError>) -> Void)
    
    // MARK: - WATCHLIST
    func isMovieWatchlisted(movieID: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func isSeriesWatchlisted(seriesID: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    
    // MARK: - FAVORITE
    func isMovieFavorited(movieID: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func isSeriesFavorited(seriesID: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    
    // MARK: - RATED
    func isMovieRated(movieID: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func isSeriesRated(seriesID: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    
    // MARK: - OTHER
    func getBelongsToCollectionDetails(collectionID: Int, completion: @escaping (Result<BelongsToCollectionDetails, NetworkError>) -> Void)
    func getTrendingPeople(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<PeopleListAPIResponse, NetworkError>) -> Void)
    
    // MARK: - LIST OF PRESET MOVIES
    func getMovieList(listType: MovieListType, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void)
    func getTrendingMoviesList(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<MovieListAPIResponse, NetworkError>) -> Void)
    
    // MARK: - LIST OF PRESET TV SERIES
    func getTVSeriesList(listType: TVSeriesListType, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getTrendingTVSeriesList(for timeWindow: TrendingTimeWindow, completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
}
