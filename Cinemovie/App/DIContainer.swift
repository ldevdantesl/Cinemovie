//
//  DIContainer.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation

final class DIContainer {
    let userService: CMUserService
    let accountStore: CMAccountStore
    let networkService: CMNetworkService
    let errorService: CMErrorService
    
    init() {
        let logger = CMNetworkLogger()
        let userService = CMUserService()
        let keychainService = CMKeychainService()
        let config = APIConfiguration(userService: userService)
        let httpClient = HTTPClient(logger: logger)
        let authContext = CMAccountStore(keychainService: keychainService)
        
        self.userService = userService
        self.accountStore = authContext
        self.networkService = CMNetworkService(httpClient: httpClient, config: config, authContext: authContext)
        self.errorService = CMErrorService()
    }
}
