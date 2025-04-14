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
    func getMovieSimilars(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void)
    func getMovieReviews(movieID: Int, completion: @escaping (Result<MovieReviewsAPIResponse, NetworkError>) -> Void)
    
    // MARK: - TV SERIES
    func getTVSeriesDetails(seriesID: Int, completion: @escaping (Result<TVSeriesDetails, NetworkError>) -> Void)
    func getTVSeriesCast(seriesID: Int, completion: @escaping (Result<MediaCastAPIResponse, NetworkError>) -> Void)
    func getTVSeriesVideos(seriesID: Int, completion: @escaping (Result<MediaVideosAPIResponse, NetworkError>) -> Void)
    
    // MARK: - PERSON
    func getPersonID(creditID: String, completion: @escaping (Result<CreditDetailsAPIResponse, NetworkError>) -> Void)
    func getPersonDetails(personID: Int, completion: @escaping (Result<PersonDetails, NetworkError>) -> Void)
    func getPersonExternalSources(personID: Int, completion: @escaping (Result<ExternalSource, NetworkError>) -> Void)
    func getPersonMovieCredits(personID: Int, completion: @escaping (Result<PersonMovieCreditAPIResponse, NetworkError>) -> Void)
    func getPersonTVShowCredits(personID: Int, completion: @escaping (Result<PersonTVShowCreditAPIResponse, NetworkError>) -> Void)
    
    // MARK: - OTHER
    func getBelongsToCollectionDetails(collectionID: Int, completion: @escaping (Result<BelongsToCollectionDetails, NetworkError>) -> Void)
    
    // MARK: - LIST OF PRESET MOVIES
    func getUpcomingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getPopularMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getTopRatedMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getNowPlayingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    
    // MARK: - LIST OF PRESET TV SERIES
    func getPopularTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getTopRatedTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getOnTheAirTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
    func getAiringTodayTVSeries(completion: @escaping (Result<TVSeriesListAPIResponse, NetworkError>) -> Void)
}
