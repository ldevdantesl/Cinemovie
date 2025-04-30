//
//  DIContainer.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation

final class DIContainer {
    let accountStore: AccountStore
    let networkService: NetworkService
    let authService: AuthService
    let tmdbService: TMDBService
    
    init() {
        self.accountStore = AccountStoreImpl()
        self.networkService = NetworkServiceImpl()
        self.authService = AuthServiceImpl(accountStore: accountStore, networkService: networkService)
        self.tmdbService = TMDBServiceImpl(accountStore: accountStore, networkService: networkService)
    }
}
