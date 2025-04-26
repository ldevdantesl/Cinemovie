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
    
    static func getTrendingMoviesEndpoint(for timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/trending/movie/\(timeWindow.rawValue)", queryParams: queryParams)
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
    
    static func getTrendingTVSeriesEndpoint(for timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/trending/tv/\(timeWindow.rawValue)", queryParams: queryParams)
    }
    
    // MARK: - TV SEASON
    static func getTVSeasonDetailsEndpoint(seriesID: Int, seasonNumber: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/\(seriesID)/season/\(seasonNumber)", queryParams: queryParams)
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
    
    static func getTrendingPeopleEndpoint(for timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/trending/person/\(timeWindow.rawValue)", queryParams: queryParams)
    }
    
    // MARK: - SEARCH
    static func getMovieSearchResultsEndpoint(query: String, extraParams: [String : String]? = nil) -> Endpoint {
        var queryParams = ["query" : query]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/search/movie", queryParams: queryParams)
    }
    
    static func getTVSeriesSearchResultsEndpoint(query: String, extraParams: [String : String]? = nil) -> Endpoint {
        var queryParams = ["query" : query]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/search/tv", queryParams: queryParams)
    }
    
    static func getPeopleSearchResultsEndpoint(query: String, extraParams: [String : String]? = nil) -> Endpoint {
        var queryParams = ["query" : query]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/search/person", queryParams: queryParams)
    }
    
    // MARK: - OTHER
    static func getBelongsToCollectionDetailsEndpoint(collectionID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/collection/\(collectionID)", queryParams: queryParams)
    }
    
    // MARK: - PRESET LIST OF MOVIES
    static func createMovieListEndpoint(listType: MovieListType, extraParams: [String: String]? = nil) -> Endpoint {
        switch listType {
        case .nowPlaying: return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/now_playing", queryParams: extraParams)
        case .popular: return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/popular", queryParams: extraParams)
        case .topRated: return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/top_rated", queryParams: extraParams)
        case .upcoming: return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/movie/upcoming", queryParams: extraParams)

        case .animation, .documentary, .action, .comedy, .drama, .history, .horror, .fantasy:
            let genreID = GenreHelper.shared.getMovieGenreID(for: movieGenreFrom(listType))
            var queryParams = [
                "with_genres": "\(genreID)"
            ]
            extraParams?.forEach { queryParams[$0] = $1 }
            return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/movie", queryParams: queryParams)
        }
    }
    
    // MARK: - PRESET LIST OF TV SERIES
    static func createTVSeriesListEndpoint(listType: TVSeriesListType, extraParams: [String: String]? = nil) -> Endpoint {
        var queryParams: [String: String] = [
            "with_watch_providers": "8|9|119|337|350|15",
            "watch_region": "US"
        ]
        extraParams?.forEach { queryParams[$0] = $1 }
        
        switch listType {
        case .popular:
            queryParams["sort_by"] = "popularity.desc"
            queryParams["without_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [.news, .reality, .talk, .warPolitics])
            return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)

        case .topRated:
            return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/tv/top_rated", queryParams: extraParams)

        case .onTheAir:
            queryParams["sort_by"] = "first_air_date.desc"
            queryParams["air_date.lte"] = CMDateFormatter.currentDateString()
            queryParams["without_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [.news, .reality, .talk, .warPolitics])
            return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)

        case .airingToday:
            queryParams["first_air_date.gte"] = CMDateFormatter.currentDateString()
            queryParams["first_air_date.lte"] = CMDateFormatter.currentDateString()
            queryParams["without_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [.news, .reality, .talk, .warPolitics])
            return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)

        case .actionAdventure, .sciFiFantasy, .drama, .animation, .crime, .kids, .comedy, .documentary:
            queryParams["sort_by"] = "popularity.desc"
            queryParams["with_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [tvGenreFrom(listType)])
            return Endpoint(baseURL: baseURL, bearerToken: bearerToken, path: "/discover/tv", queryParams: queryParams)
        }
    }
    
    // MARK: - PRIVATE FUNC
    private static func movieGenreFrom(_ listType: MovieListType) -> MovieGenreName {
        switch listType {
        case .animation: return .animation
        case .documentary: return .documentary
        case .action: return .action
        case .comedy: return .comedy
        case .drama: return .drama
        case .history: return .history
        case .horror: return .horror
        case .fantasy: return .fantasy
        default: fatalError("Invalid genre list type for genreFrom()")
        }
    }
    
    private static func tvGenreFrom(_ listType: TVSeriesListType) -> TVSeriesGenreName {
        switch listType {
        case .actionAdventure: return .actionAdventure
        case .sciFiFantasy: return .sciFiFantasy
        case .drama: return .drama
        case .animation: return .animation
        case .crime: return .crime
        case .kids: return .kids
        case .comedy: return .comedy
        case .documentary: return .documentary
        default: fatalError("Invalid genre list type for genreFrom()")
        }
    }
}
