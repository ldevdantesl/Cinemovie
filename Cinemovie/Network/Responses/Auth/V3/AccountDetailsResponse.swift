//
//  AccountDetailsResponse.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

struct AccountDetailsAPIResponse: Decodable {
    let id: Int
    let name: String?
    let username: String?
}
