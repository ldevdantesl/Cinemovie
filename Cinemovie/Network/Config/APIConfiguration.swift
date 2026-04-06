//
//  APIConfiguration.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol APIConfigurationProtocol {
    var language: String { get }
    var region: String { get }
    var isAdultIncluded: Bool { get }
}

final class APIConfiguration: APIConfigurationProtocol {
    private let userService: UserServiceProtocol
    
    var language: String { userService.userLanguage.iso_639_1 }
    var region: String { userService.region.iso_3166_1 }
    var isAdultIncluded: Bool { userService.adultEnabled }
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
}
