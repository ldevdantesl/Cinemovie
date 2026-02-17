//
//  UserCustomListsResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.05.2025.
//

import Foundation

struct UserListsResponse: APIResponse {
    let page: Int
    let results: [UserList]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
