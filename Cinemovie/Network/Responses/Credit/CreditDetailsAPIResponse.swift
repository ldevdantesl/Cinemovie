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
    let media: AnyMedia

    enum CodingKeys: String, CodingKey {
        case id, department, job, person, media
        case creditType = "credit_type"
        case mediaType = "media_type"
    }
}
