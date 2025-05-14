//
//  TMDBEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.03.2025.
//

import Foundation

struct TMDBEndpoints {
    static let baseURL = CONSTANTS.baseURLString
    static let baseURLV4 = CONSTANTS.baseURLV4String
    static let apiReadAccessToken = CONSTANTS.apiReadAcessToken
    static let apiKey = CONSTANTS.apiKey

    // MARK: - MOVIE
    static func getMovieCastEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/\(movieID)/credits", queryParams: queryParams)
    }
    
    static func getMovieAccountStateEndpoint(movieID: Int, sessionID: String) -> Endpoint {
        let queryParams = ["session_id" : sessionID]
        return Endpoint(baseURL: baseURL, bearerToken: apiReadAccessToken, path: "/movie/\(movieID)/account_states", queryParams: queryParams)
    }

    static func getMovieDetailsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/\(movieID)", queryParams: queryParams)
    }

    static func getMovieSimilarsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/\(movieID)/similar", queryParams: queryParams)
    }

    static func getMovieRecommendationsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/\(movieID)/recommendations", queryParams: queryParams)
    }

    static func getMovieReviewsEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/\(movieID)/reviews", queryParams: queryParams)
    }

    static func getMovieVideosEndpoint(movieID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/\(movieID)/videos", queryParams: queryParams)
    }

    static func getTrendingMoviesEndpoint(for timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/trending/movie/\(timeWindow.rawValue)", queryParams: queryParams)
    }

    // MARK: - TV SERIES
    static func getTVSeriesDetailsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)", queryParams: queryParams)
    }
    
    static func getTVSeriesAccountStateEndpoint(seriesID: Int, sessionID: String) -> Endpoint {
        let queryParams = ["session_id" : sessionID]
        return Endpoint(baseURL: baseURL, bearerToken: apiReadAccessToken, path: "/tv/\(seriesID)/account_states", queryParams: queryParams)
    }

    static func getTVSeriesCastEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)/credits", queryParams: queryParams)
    }

    static func getTVSeriesVideosEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)/videos", queryParams: queryParams)
    }

    static func getTVSeriesReviewsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)/reviews", queryParams: queryParams)
    }

    static func getTVSeriesSimilarsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)/similar", queryParams: queryParams)
    }

    static func getTVSeriesRecommendsEndpoint(seriesID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)/recommendations", queryParams: queryParams)
    }

    static func getTrendingTVSeriesEndpoint(for timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/trending/tv/\(timeWindow.rawValue)", queryParams: queryParams)
    }

    // MARK: - TV SEASON
    static func getTVSeasonDetailsEndpoint(seriesID: Int, seasonNumber: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/\(seriesID)/season/\(seasonNumber)", queryParams: queryParams)
    }

    // MARK: - PERSON
    static func getPersonIDEndpoint(creditID: String) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/credit/\(creditID)")
    }

    static func getPersonDetailsEndpoint(personID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/person/\(personID)", queryParams: queryParams)
    }

    static func getPersonExternalSourcesEndpoint(personID: Int) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/person/\(personID)/external_ids")
    }

    static func getPersonMovieCredits(personID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/person/\(personID)/movie_credits", queryParams: queryParams)
    }

    static func getPersonTVShowCredits(personID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/person/\(personID)/tv_credits", queryParams: queryParams)
    }

    static func getTrendingPeopleEndpoint(for timeWindow: TrendingTimeWindow, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/trending/person/\(timeWindow.rawValue)", queryParams: queryParams)
    }

    static func getPersonImagesEndpoint(personID: Int) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/person/\(personID)/images")
    }

    // MARK: - SEARCH
    static func getMovieSearchResultsEndpoint(query: String, extraParams: [String : String]? = nil) -> Endpoint {
        var queryParams = ["query" : query]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/search/movie", queryParams: queryParams)
    }

    static func getTVSeriesSearchResultsEndpoint(query: String, extraParams: [String : String]? = nil) -> Endpoint {
        var queryParams = ["query" : query]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/search/tv", queryParams: queryParams)
    }

    static func getPeopleSearchResultsEndpoint(query: String, extraParams: [String : String]? = nil) -> Endpoint {
        var queryParams = ["query" : query]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/search/person", queryParams: queryParams)
    }

    // MARK: - ACCOUNT LIST
    static func getAccountListMediaEndpoint(
        accountID: String, accessToken: String, mediaType: MediaTypes,
        accountListType: AccountListTypes, extraParams: [String : String]? = nil
    ) -> Endpoint {
        var queryParams = ["sort_by" : "created_at.desc"]
        extraParams?.forEach { queryParams[$0] = $1 }
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/account/\(accountID)/\(mediaType.rawValue)/\(accountListType.titleForEndpointsV4)", queryParams: queryParams)
    }
    
    static func addOrRemoveMediaInAccountListEndpoint(accountID: String, sessionID: String, listType: AccountListTypes, mediaID: Int, mediaType: MediaTypes, adding: Bool) -> Endpoint {
        let bodyParam: [String : Any] = [
            "media_type" : mediaType.rawValue,
            "media_id" : mediaID,
            listType.titleForEndpointsV3 : adding
        ]
        let body = CMJSONSerializer.dataToJSON(json: bodyParam)
        let queryParams = ["session_id" : sessionID]
        return Endpoint(baseURL: baseURL, bearerToken: apiReadAccessToken, path: "/account/\(accountID)/\(listType.titleForEndpointsV3)", method: .POST, queryParams: queryParams, body: body)
    }
    
    // MARK: - USER LIST
    static func getUserListDetailsEndpoint(listID: Int, language: String, page: Int, accessToken: String) -> Endpoint {
        let params = ["language" : language, "page" : page.description]
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list/\(listID)", queryParams: params)
    }
    
    static func getUserListsEndpoint(accountID: String, accessToken: String, page: Int) -> Endpoint {
        let queryParams = ["page" : String(page)]
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/account/\(accountID)/lists", queryParams: queryParams)
    }
    
    static func createUserListEndpoint(name: String, description: String?, isPublic: Bool, language: String, accessToken: String) -> Endpoint {
        var json: [String: Any] = [
            "name" : name,
            "iso_639_1" : language,
            "public" : isPublic
        ]
        if let description = description {
            json["description"] = description
        }
        
        let body = CMJSONSerializer.dataToJSON(json: json)
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list", method: .POST, body: body)
    }
    
    static func updateUserListEndpoint(listID: Int, newName: String, newDescription: String?, isPublic: Bool, language: String, accessToken: String) -> Endpoint {
        var json: [String: Any] = [
            "name" : newName,
            "iso_639_1" : language,
            "public" : isPublic
        ]
        if let description = newDescription {
            json["description"] = description
        }
        
        let body = CMJSONSerializer.dataToJSON(json: json)
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list/\(listID)", method: .PUT, body: body)
    }
    
    static func addOrRemoveItemInUserListEndpoint(listID: Int, mediaID: Int, mediaType: MediaTypes, accessToken: String, adding: Bool) -> Endpoint  {
        let json: [String: Any] = [
            "items": [
                [
                    "media_type": mediaType.rawValue,
                    "media_id": mediaID
                ]
            ]
        ]
        let body = CMJSONSerializer.dataToJSON(json: json)
        let method: Endpoint.HTTPMethod = adding ? .POST : .DELETE
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list/\(listID)/items", method: method, body: body)
    }
    
    static func userListItemStatusEndpoint(listID: Int, mediaID: Int, mediaType: MediaTypes, accessToken: String) -> Endpoint {
        let queryParams: [String : String] = [
            "mediaID" : mediaID.description,
            "media_type" : mediaType.rawValue
        ]
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list/\(listID)/item_status", queryParams: queryParams)
    }
    
    static func clearUserListEndpoint(listID: Int, accessToken: String) -> Endpoint {
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list/\(listID)/clear")
    }
    
    static func deleteUserListEndpoint(listID: Int, accessToken: String) -> Endpoint {
        return Endpoint(baseURL: baseURLV4, bearerToken: accessToken, path: "/list/\(listID)", method: .DELETE)
    }

    // MARK: - OTHER
    static func getBelongsToCollectionDetailsEndpoint(collectionID: Int, queryParams: [String : String]? = nil) -> Endpoint {
        Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/collection/\(collectionID)", queryParams: queryParams)
    }

    // MARK: - PRESET LIST OF MOVIES
    static func createMovieListEndpoint(listType: MovieListType, extraParams: [String: String]? = nil) -> Endpoint {
        switch listType {
        case .nowPlaying: return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/now_playing", queryParams: extraParams)
        case .popular: return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/popular", queryParams: extraParams)
        case .topRated: return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/top_rated", queryParams: extraParams)
        case .upcoming: return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/movie/upcoming", queryParams: extraParams)

        case .animation, .documentary, .action, .comedy, .drama, .history, .horror, .fantasy:
            let genreID = GenreHelper.shared.getMovieGenreID(for: listType.genreName)
            var queryParams = [
                "with_genres": "\(genreID)"
            ]
            extraParams?.forEach { queryParams[$0] = $1 }
            return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/discover/movie", queryParams: queryParams)
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
            return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/discover/tv", queryParams: queryParams)

        case .topRated:
            return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/tv/top_rated", queryParams: extraParams)

        case .onTheAir:
            queryParams["sort_by"] = "first_air_date.desc"
            queryParams["air_date.lte"] = CMDateFormatter.currentDateString()
            queryParams["without_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [.news, .reality, .talk, .warPolitics])
            return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/discover/tv", queryParams: queryParams)

        case .airingToday:
            queryParams["first_air_date.gte"] = CMDateFormatter.currentDateString()
            queryParams["first_air_date.lte"] = CMDateFormatter.currentDateString()
            queryParams["without_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [.news, .reality, .talk, .warPolitics])
            return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/discover/tv", queryParams: queryParams)

        case .actionAdventure, .sciFiFantasy, .drama, .animation, .crime, .kids, .comedy, .documentary:
            queryParams["sort_by"] = "popularity.desc"
            queryParams["with_genres"] = GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [listType.genreName])
            return Endpoint(baseURL: baseURL, apiKey: apiKey, path: "/discover/tv", queryParams: queryParams)
        }
    }
}
