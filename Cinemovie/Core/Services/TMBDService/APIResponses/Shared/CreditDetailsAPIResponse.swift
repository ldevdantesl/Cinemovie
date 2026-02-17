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
    let media: AnyMedia
    
    enum CodingKeys: String, CodingKey {
        case creditType = "credit_type"
        case department, job, media
        case mediaType = "media_type"
        case id, person
    }
}
