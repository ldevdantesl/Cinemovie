//
//  ResultAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct PaginatedAPIResponse<T: Decodable>: Decodable {
    let id: Int?
    let dates: Dates?
    let page: Int?
    let result: [T]
    let totalPages: Int?
    let totalResults: Int?
}
