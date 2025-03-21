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
    
    // MARK: - MOVIE DETAILS
    static func getMovieCastEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)/credits", queryParams: queryParams)
    }
    
    static func getMovieDetailsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/\(movieID)", queryParams: queryParams)
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
    
    // MARK: - PRESET LIST MOVIES
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
}
