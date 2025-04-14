//
//  TMDBEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import Foundation

struct TMDBEndpoints {
    static let baseURL = CONSTANTS.baseURLString
    static let bearerToken = CONSTANTS.bearerToken
    
    // MARK: - MOVIE
    static func getMovieCastEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)/credits", queryParams: queryParams)
    }
    
    static func getMovieDetailsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)", queryParams: queryParams)
    }
    
    static func getMovieSimilarsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)/similar", queryParams: queryParams)
    }
    
    static func getMovieRecommendationsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)/recommendations", queryParams: queryParams)
    }
    
    static func getMovieReviewsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)/reviews", queryParams: queryParams)
    }
    
    static func getMovieVideosEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)/videos", queryParams: queryParams)
    }
    
    // MARK: - TV SERIES
    static func getTVSeriesDetailsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)", queryParams: queryParams)
    }
    
    static func getTVSeriesCastEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)/credits", queryParams: queryParams)
    }
    
    static func getTVSeriesVideosEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)/videos", queryParams: queryParams)
    }
    
    // MARK: - PERSON
    static func getPersonIDEndpoint(creditID: String) -> Endpoint {
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/credit/\(creditID)")
    }
    
    static func getPersonDetailsEndpoint(personID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/person/\(personID)", queryParams: queryParams)
    }
    
    static func getPersonExternalSourcesEndpoint(personID: Int) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/person/\(personID)/external_ids")
    }
    
    static func getPersonMovieCredits(personID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/person/\(personID)/movie_credits", queryParams: queryParams)
    }
    
    static func getPersonTVShowCredits(personID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/person/\(personID)/tv_credits", queryParams: queryParams)
    }
    
    // MARK: - OTHER
    static func getBelongsToCollectionDetailsEndpoint(collectionID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/collection/\(collectionID)", queryParams: queryParams)
    }
    
    // MARK: - PRESET LIST OF MOVIES
    static func getNowPlayingMoviesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/now_playing", queryParams: queryParams)
    }
    
    static func getPopularMoviesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/popular", queryParams: queryParams)
    }
    
    static func getTopRatedMoviesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/top_rated", queryParams: queryParams)
    }
    
    static func getUpcomingMoviesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/upcoming", queryParams: queryParams)
    }
    
    // MARK: - PRESET LIST OF TV SERIES
    static func getPopularTVSeriesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/popular", queryParams: queryParams)
    }
    
    static func getTopRatedTVSeriesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/top_rated", queryParams: queryParams)
    }
    
    static func getOnTheAirTVSeriesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/on_the_air", queryParams: queryParams)
    }
    
    static func getAiringTodayTVSeriesEndpoint(queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/airing_today", queryParams: queryParams)
    }
}
