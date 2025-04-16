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
    
    static func getTVSeriesReviewsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)/reviews", queryParams: queryParams)
    }
    
    static func getTVSeriesSimilarsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)/similar", queryParams: queryParams)
    }
    
    static func getTVSeriesRecommendsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)/recommendations", queryParams: queryParams)
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
    static func getPopularTVSeriesEndpoint(extraParams: [String : String]?) -> Endpoint {
        var queryParams = [
            "sort_by": "popularity.desc",
            "without_genres": "10764,10763,10767",
            "with_watch_providers": "8|9|119|337|350|15",
            "watch_region" : "US",
            "include_null_watch_providers": "false"
        ]
        
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)
    }

    static func getTopRatedTVSeriesEndpoint(extraParams: [String : String]?) -> Endpoint {
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/top_rated", queryParams: extraParams)
    }

    static func getOnTheAirTVSeriesEndpoint(extraParams: [String : String]?) -> Endpoint {
        var queryParams = [
            "sort_by": "first_air_date.desc",
            "air_date.lte": CMDateFormatter.currentDateString(),
            "without_genres": "10764,10763,10767",
            "with_watch_providers": "8|9|119|337|350|15",
            "watch_region": "US",
            "include_null_watch_providers": "false"
        ]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)
    }

    static func getAiringTodayTVSeriesEndpoint(extraParams: [String : String]?) -> Endpoint {
        var queryParams = [
            "first_air_date.gte": CMDateFormatter.currentDateString(),
            "first_air_date.lte": CMDateFormatter.currentDateString(),
            "without_genres": "10764,10763,10767",
            "with_watch_providers": "8|9|119|337|350|15",
            "watch_region": "US",
            "include_null_watch_providers": "false"
        ]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)
    }
}
