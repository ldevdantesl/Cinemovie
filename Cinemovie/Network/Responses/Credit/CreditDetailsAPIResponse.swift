//
//  CreditDetailsAPIResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

struct CreditDetailsAPIResponse: Decodable {
    let id: String
    let creditType: String
    let department: String
    let job: String
    let mediaType: String
    let person: Person
    let media: MediaProtocol

    enum CodingKeys: String, CodingKey {
        case id, department, job, person, media
        case creditType = "credit_type"
        case mediaType = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        creditType = try container.decode(String.self, forKey: .creditType)
        department = try container.decode(String.self, forKey: .department)
        job = try container.decode(String.self, forKey: .job)
        mediaType = try container.decode(String.self, forKey: .mediaType)
        person = try container.decode(Person.self, forKey: .person)

        switch mediaType {
        case "movie":
            media = try container.decode(Movie.self, forKey: .media)
        case "tv":
            media = try container.decode(TVSeries.self, forKey: .media)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .mediaType,
                in: container,
                debugDescription: "Unknown media_type: \(mediaType)"
            )
        }
    }
}
