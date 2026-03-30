//
//  AccountListEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

enum AccountListEndpoints: Endpoint {
    case getMedia(accountID: String, accessToken: String, mediaType: MediaTypes, listType: AccountListTypes, page: Int)
    case addMediaInAccountList(accountID: String, accessToken: String, mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes)
    case removeMediaInAccountList(accountID: String, accessToken: String, mediaID: Int, listType: AccountListTypes, mediaType: MediaTypes)
    
    var baseURL: String {
        switch self {
        case .getMedia: return CONSTANTS.baseURLV4String
        default: return CONSTANTS.baseURLString
        }
    }
    
    var auth: EndpointAuth {
        switch self {
        case .getMedia(_, let accessToken, _, _, _),
                .addMediaInAccountList(_, let accessToken, _, _, _),
                .removeMediaInAccountList(_, let accessToken, _, _, _):
            return .bearer(accessToken)
        }
    }
    
    var path: String {
        switch self {
        case .getMedia(let accountID, _, let mediaType, let listType, _):
            return "/account/\(accountID)/\(mediaType.rawValue)/\(listType.titleForEndpointsV4)"
        case .addMediaInAccountList(let accountID, _, _, let listType, _):
            return "/account/\(accountID)/\(listType.titleForEndpointsV3)"
        case .removeMediaInAccountList(let accountID, _, _, let listType, _):
            return "/account/\(accountID)/\(listType.titleForEndpointsV3)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMedia: return .get
        default: return .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getMedia(_, _, _, _, let page):
            return ["sort_by" : "created_at.desc", "page" : "\(page.description)"].toQueryItems()
        default: return .none
        }
    }
    
    var body: Data? {
        switch self {
        case .addMediaInAccountList(_, _, let mediaID, let listType, let mediaType):
            let bodyParam: [String : Any] = [
                "media_type" : mediaType.rawValue,
                "media_id" : mediaID,
                listType.titleForEndpointsV4 : true
            ]
            return CMJSONSerializer.dataToJSON(json: bodyParam)
        case .removeMediaInAccountList(_, _, let mediaID, let listType, let mediaType):
            let bodyParam: [String : Any] = [
                "media_type" : mediaType.rawValue,
                "media_id" : mediaID,
                listType.titleForEndpointsV4 : false
            ]
            return CMJSONSerializer.dataToJSON(json: bodyParam)
        default: return .none
        }
    }
}
