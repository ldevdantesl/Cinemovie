//
//  CreditDetailsAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 20.03.2025.
//

import Foundation

struct CreditDetailsAPIResponse: APIResponse {
    let id: String
    let creditType: String
    let department: String
    let job: String
    let mediaType: String
    let person: QueryPerson
    let media: Media
    
    enum CodingKeys: String, CodingKey {
        case creditType = "credit_type"
        case department, job, media
        case mediaType = "media_type"
        case id, person
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        creditType = try container.decode(String.self, forKey: .creditType)
        department = try container.decode(String.self, forKey: .department)
        job = try container.decode(String.self, forKey: .job)
        mediaType = try container.decode(String.self, forKey: .mediaType)
        person = try container.decode(QueryPerson.self, forKey: .person)
        
        let mediaDecoder = try container.superDecoder(forKey: .media)
     
        switch mediaType {
        case "movie": media = try QueryMovie(from: mediaDecoder)
        case "tv": media = try QueryTVShow(from: mediaDecoder)
        default: throw DecodingError.dataCorruptedError(forKey: .mediaType, in: container, debugDescription: "Unsupported media type: \(mediaType)")
        }
    }
}
