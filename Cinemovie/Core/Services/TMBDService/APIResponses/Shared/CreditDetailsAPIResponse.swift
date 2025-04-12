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
    let person: Person
    let media: Media
    
    enum CodingKeys: String, CodingKey {
        case creditType = "credit_type"
        case department, job, media
        case mediaType = "media_type"
        case id, person
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.creditType = try container.decode(String.self, forKey: .creditType)
        self.department = try container.decode(String.self, forKey: .department)
        self.job = try container.decode(String.self, forKey: .job)
        self.mediaType = try container.decode(String.self, forKey: .mediaType)
        self.person = try container.decode(Person.self, forKey: .person)
        
        let mediaDecoder = try container.superDecoder(forKey: .media)
        self.media = try AnyMedia(from: mediaDecoder).value
    }
}
