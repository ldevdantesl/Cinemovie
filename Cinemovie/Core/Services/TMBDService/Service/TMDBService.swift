//
//  TMDBService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 5.02.2025.
//

import Foundation

protocol TMDBService: AnyObject {
    // MARK: - MOVIE DETAILS
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void)
    func getMovieCast(movieID: Int, completion: @escaping (Result<MovieCastAPIResponse, NetworkError>) -> Void)
    func getMovieRecommendations(movieID: Int, completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getMovieVideos(movieID: Int, completion: @escaping (Result<MovieVideosAPIResponse, NetworkError>) -> Void)
    func getMovieReviews(movieID: Int, completion: @escaping (Result<MovieReviewsAPIResponse, NetworkError>) -> Void)
    
    // MARK: - LIST OF PRESET MOVIES
    func getUpcomingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getPopularMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getTopRatedMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
    func getNowPlayingMovies(completion: @escaping (Result<MovieListsAPIResponse, NetworkError>) -> Void)
}
