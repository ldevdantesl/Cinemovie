//
//  DIContainer.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation

final class DIContainer {
    let userService: CMUserService
    let authService: AuthServiceProtocol
    let authContext: AuthContextProtocol
    let networkService: CMNetworkService
    let errorService: CMErrorService
    
    init() {
        let logger = CMNetworkLogger()
        let userService = CMUserService()
        let keychainService = CMKeychainService()
        let config = APIConfiguration(userService: userService)
        let httpClient = HTTPClient(logger: logger)
        let authContext = CMAccountStore(keychainService: keychainService)
        let networkService = CMNetworkService(httpClient: httpClient, config: config, authContext: authContext)
        
        self.userService = userService
        self.authService = CMAuthService(httpClient: httpClient, authContext: authContext)
        self.networkService = networkService
        self.errorService = CMErrorService()
        self.authContext = authContext
    }
}
