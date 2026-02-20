//
//  UserListEndpoints.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

enum UserListEndpoints: Endpoint {
    case getUserLists(accountID: String, accessToken: String, page: Int)
    case getUserListDetails(accessToken: String, listID: Int, extraParams: [String : String]?, page: Int)
    case createUserList(accessToken: String,name: String, description: String?, queryParams: [String : String]?, isPublic: Bool)
    case addMediaInUserList(accessToken: String, listID: Int, mediaID: Int, mediaType: MediaTypes)
    case removeMediaInUserList(accessToken: String, listID: Int, mediaID: Int, mediaType: MediaTypes)
    case removeUserList(accessToken: String, listID: Int)
    case getItemStatusInUserList(accessToken: String, listID: Int, mediaID: Int, mediaType: MediaTypes)
    
    var path: String {
        switch self {
        case .getUserLists(let accountID, _, _):
            return "/account/\(accountID)/lists"
        case .getUserListDetails(_, let listID, _, _):
            return "/list/\(listID)"
        case .createUserList:
            return "/list"
        case .addMediaInUserList(_, let listID, _, _):
            return "/list/\(listID)/items"
        case .removeMediaInUserList(_, let listID, _, _):
            return "/list/\(listID)/items"
        case .removeUserList(_, let listID):
            return "/list/\(listID)"
        case .getItemStatusInUserList(_, let listID, _, _):
            return "/list/\(listID)/item_status"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserLists, .getUserListDetails, .getItemStatusInUserList: return .get
        case .createUserList, .addMediaInUserList: return .post
        case .removeMediaInUserList, .removeUserList: return .delete
        }
    }
    
    var body: Data? {
        switch self {
        case .createUserList(_, let name, let description, _, let isPublic):
            var json: [String: Any] = [
                "name" : name,
                "iso_639_1" : "en",
                "public" : isPublic
            ]
            
            if let description = description {
                json["description"] = description
            }
            return CMJSONSerializer.dataToJSON(json: json)
        case .addMediaInUserList(_, _, let mediaID, let mediaType), .removeMediaInUserList(_, _, let mediaID, let mediaType):
            let json: [String: Any] = [
                "items": [
                    [
                        "media_type": mediaType.rawValue,
                        "media_id": mediaID
                    ]
                ]
            ]
            return CMJSONSerializer.dataToJSON(json: json)
        default: return .none
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getUserLists(let accountID, let accessToken, let page):
            return ["page" : page.description].toQueryItems()
        case .getUserListDetails(let accessToken, let listID, let extraParams, let page):
            var queryItems = extraParams
            queryItems?["page"] = page.description
            return queryItems?.toQueryItems()
        case .getItemStatusInUserList(let accessToken, let listID, let mediaID, let mediaType):
            return ["media_id" : mediaID.description, "media_type" : mediaType.rawValue].toQueryItems()
        default: return .none
        }
    }
}
