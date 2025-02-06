//
//  DIContainer.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation

final class DIContainer {
    let networkService: NetworkService
    let authService: AuthService
    let tmdbService: TMDBService
    
    init() {
        self.networkService = NetworkServiceImpl()
        self.authService = AuthServiceImpl(networkService: networkService)
        self.tmdbService = TMBDServiceImpl(networkService: networkService)
    }
}
