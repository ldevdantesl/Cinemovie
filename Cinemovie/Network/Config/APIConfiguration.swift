//
//  APIConfiguration.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 18.02.2026.
//

import Foundation

protocol APIConfigurationProtocol {
    var language: String { get }
}

final class APIConfiguration: APIConfigurationProtocol {
    private let userService: UserServiceProtocol
    
    var language: String { userService.userLanguage }
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
}
