//
//  TVSeriesEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

enum TVSeriesEndpoints: Endpoint {
    case details(seriesID: Int, queryParams: [String: String]? = nil)
    case accountState(seriesID: Int, sessionID: String)
    case cast(seriesID: Int, queryParams: [String: String]? = nil)
    case videos(seriesID: Int, queryParams: [String: String]? = nil)
    case reviews(seriesID: Int, queryParams: [String: String]? = nil)
    case similar(seriesID: Int, queryParams: [String: String]? = nil)
    case recommendations(seriesID: Int, queryParams: [String: String]? = nil)
    case trending(timeWindow: TrendingTimeWindow, queryParams: [String: String]? = nil)
    case seasonDetails(seriesID: Int, seasonNumber: Int, queryParams: [String: String]? = nil)
    case list(listType: TVSeriesListType, extraParams: [String: String]? = nil)
    case rate(seriesID: Int, sessionID: String, value: Double)
    case removeRating(seriesID: Int, sessionID: String)

    var method: HTTPMethod {
        switch self {
        case .rate: return .post
        case .removeRating: return .delete
        default: return .get
        }
    }
    
    var path: String {
        switch self {
        case .details(let id, _):                   return "/tv/\(id)"
        case .accountState(let id, _):              return "/tv/\(id)/account_states"
        case .cast(let id, _):                      return "/tv/\(id)/credits"
        case .videos(let id, _):                    return "/tv/\(id)/videos"
        case .reviews(let id, _):                   return "/tv/\(id)/reviews"
        case .similar(let id, _):                   return "/tv/\(id)/similar"
        case .recommendations(let id, _):           return "/tv/\(id)/recommendations"
        case .trending(let tw, _):                  return "/trending/tv/\(tw.rawValue)"
        case .seasonDetails(let id, let season, _): return "/tv/\(id)/season/\(season)"
        case .rate(let id, _, _):                   return "/tv/\(id)/rating"
        case .removeRating(let id, _):              return "/tv/\(id)/rating"
        case .list(let listType, _):
            switch listType {
            case .topRated: return "/tv/top_rated"
            default:        return "/discover/tv"
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
             .videos(_, let params),
             .reviews(_, let params),
             .similar(_, let params),
             .recommendations(_, let params),
             .trending(_, let params),
             .seasonDetails(_, _, let params):
            return params?.toQueryItems()

        case .accountState(_, let sessionID), .rate(_, let sessionID, _), .removeRating(_, let sessionID):
            return [URLQueryItem(name: "session_id", value: sessionID)]

        case .list(let listType, let extraParams):
            switch listType {
            case .topRated:
                return extraParams?.toQueryItems()

            case .popular:
                var items = baseWatchProviderQueryItems(extraParams)
                items.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
                items.append(URLQueryItem(name: "without_genres", value: excludedGenres()))
                appendExtra(extraParams, to: &items)
                return items

            case .onTheAir:
                var items = baseWatchProviderQueryItems(extraParams)
                items.append(URLQueryItem(name: "sort_by", value: "first_air_date.desc"))
                items.append(URLQueryItem(name: "air_date.lte", value: CMDateFormatter.currentDateString()))
                items.append(URLQueryItem(name: "without_genres", value: excludedGenres()))
                appendExtra(extraParams, to: &items)
                return items

            case .airingToday:
                var items = baseWatchProviderQueryItems(extraParams)
                items.append(URLQueryItem(name: "first_air_date.gte", value: CMDateFormatter.currentDateString()))
                items.append(URLQueryItem(name: "first_air_date.lte", value: CMDateFormatter.currentDateString()))
                items.append(URLQueryItem(name: "without_genres", value: excludedGenres()))
                appendExtra(extraParams, to: &items)
                return items

            case .actionAdventure, .sciFiFantasy, .drama, .animation, .crime, .kids, .comedy, .documentary:
                var items = baseWatchProviderQueryItems(extraParams)
                items.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
                items.append(URLQueryItem(name: "with_genres", value: GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [listType.genreName])))
                appendExtra(extraParams, to: &items)
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

    // MARK: - Private Helpers
    private func baseWatchProviderQueryItems(_ extraParams: [String: String]?) -> [URLQueryItem] {
        [
            URLQueryItem(name: "with_watch_providers", value: "8|9|119|337|350|15"),
            URLQueryItem(name: "watch_region", value: extraParams?["region"] ?? "US")
        ]
    }

    private func excludedGenres() -> String {
        GenreHelper.shared.getTVSeriesGenreIDsSeperatedByComma(genres: [.news, .reality, .talk, .warPolitics])
    }

    private func appendExtra(_ params: [String: String]?, to items: inout [URLQueryItem]) {
        if let params {
            items.append(contentsOf: params.toQueryItems())
        }
    }
}
