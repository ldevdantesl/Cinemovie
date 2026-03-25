//
//  AppCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let window: UIWindow?

    private let authContext: AuthContextProtocol
    private let accountStore: AccountStoreProtocol
    private let networkService: NetworkServiceProtocol
    
    init(window: UIWindow?, authService: AuthContextProtocol, accountStore: AccountStoreProtocol, networkService: NetworkServiceProtocol) {
        self.window = window
        self.authContext = authService
        self.networkService = networkService
        self.accountStore = accountStore
    }
    
    func start() {
        let splashVC = SplashScreenVC()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.checkAuthentication()
        }
    }
    
    private func checkAuthentication() {
        authContext.isLoggedIn ? showMainApp() : showLoginPage()
    }
    
    func showMainApp() {
        guard let window = window else {
            return
        }
        
        let tabCoordinator = TabCoordinator(authContext: authContext, networkService: networkService, appCoordinator: self)
        tabCoordinator.start()
    
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.window?.rootViewController = tabCoordinator.tabBarController
            }
        }
        
    }
    
    func showLoginPage() {
        guard let window = window else {
            return
        }
        
        let loginVC = LoginScreenAssembler.assemble(networkService: networkService, accountStore: accountStore, appCoordinator: self)
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.window?.rootViewController = loginVC
            }
        }
    }
}
