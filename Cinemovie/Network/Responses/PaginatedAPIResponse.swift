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
    let results: [T]
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        dates = try container.decodeIfPresent(Dates.self, forKey: .dates)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        
        if container.contains(.results) {
            var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
            var decodedResults: [T] = []
            
            while !resultsContainer.isAtEnd {
                if let item = try? resultsContainer.decode(T.self) {
                    decodedResults.append(item)
                } else {
                    _ = try? resultsContainer.decode(EmptyDecodable.self)
                }
            }
            
            self.results = decodedResults
        } else {
            self.results = []
        }
    }
}

private struct EmptyDecodable: Decodable {}
