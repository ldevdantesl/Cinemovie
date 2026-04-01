//
//  EndpointAuth.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

enum EndpointAuth {
    case apiKey(String)
    case bearer(String)
    case none
}
