//
//  DIContainer.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation

final class DIContainer {
    let networkService: NetworkService = NetworkServiceImpl()
    lazy var authService: AuthService = AuthServiceImpl(networkService: networkService)
}
