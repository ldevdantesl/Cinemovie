//
//  MovieEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

enum MovieEndpoints: Endpoint {
    case details(movieID: Int, queryParams: [String: String]? = nil)
    case cast(movieID: Int, queryParams: [String: String]? = nil)
    case accountState(movieID: Int, sessionID: String)
    case similar(movieID: Int, queryParams: [String: String]? = nil)
    case recommendations(movieID: Int, queryParams: [String: String]? = nil)
    case reviews(movieID: Int, queryParams: [String: String]? = nil)
    case videos(movieID: Int, queryParams: [String: String]? = nil)
    case trending(timeWindow: TrendingTimeWindow, queryParams: [String: String]? = nil)
    case list(listType: MovieListType, extraParams: [String: String]? = nil)
    case rate(movieID: Int, sessionID: String, value: Double)
    case removeRating(movieID: Int, sessionID: String)

    var method: HTTPMethod {
        switch self {
        case .rate: return .post
        case .removeRating: return .delete
        default: return .get
        }
    }
    
    var path: String {
        switch self {
        case .details(let id, _):           return "/movie/\(id)"
        case .cast(let id, _):              return "/movie/\(id)/credits"
        case .accountState(let id, _):      return "/movie/\(id)/account_states"
        case .similar(let id, _):           return "/movie/\(id)/similar"
        case .recommendations(let id, _):   return "/movie/\(id)/recommendations"
        case .reviews(let id, _):           return "/movie/\(id)/reviews"
        case .videos(let id, _):            return "/movie/\(id)/videos"
        case .trending(let tw, _):          return "/trending/movie/\(tw.rawValue)"
        case .rate(let id, _, _):           return "/movie/\(id)/rating"
        case .removeRating(let id, _):      return "/movie/\(id)/rating"
        case .list(let listType, _):
            switch listType {
            case .nowPlaying:   return "/movie/now_playing"
            case .popular:      return "/movie/popular"
            case .topRated:     return "/movie/top_rated"
            case .upcoming:     return "/movie/upcoming"
            case .animation, .documentary, .action, .comedy, .drama, .history, .horror, .fantasy:
                return "/discover/movie"
            }
        }
    }

    var auth: EndpointAuth {
        switch self {
        case .accountState:
            return .bearer(CONSTANTS.apiReadAcessToken)
        default:
            return .apiKey(CONSTANTS.apiKey)
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .details(_, let params),
             .cast(_, let params),
             .similar(_, let params),
             .recommendations(_, let params),
             .reviews(_, let params),
             .videos(_, let params),
             .trending(_, let params):
            return params?.toQueryItems()

        case .accountState(_, let sessionID), .rate(_, let sessionID, _), .removeRating(_, let sessionID):
            return [URLQueryItem(name: "session_id", value: sessionID)]

        case .list(let listType, let extraParams):
            switch listType {
            case .nowPlaying, .popular, .topRated, .upcoming:
                return extraParams?.toQueryItems()
            case .animation, .documentary, .action, .comedy, .drama, .history, .horror, .fantasy:
                let genreID = GenreHelper.shared.getMovieGenreID(for: listType.genreName)
                var items = [URLQueryItem(name: "with_genres", value: "\(genreID)")]
                if let extraParams {
                    items.append(contentsOf: extraParams.toQueryItems())
                }
                return items
            }
        }
    }
    
    var body: Data? {
        switch self {
        case .rate(_, _, let value):
            let json = ["value" : value]
            return try? JSONEncoder().encode(json)
        default: return nil
        }
    }
}
