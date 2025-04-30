//
//  AppCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow?

    private let authService: AuthService
    private let tmdbService: TMDBService
    
    init(window: UIWindow?, authService: AuthService, tmdbService: TMDBService) {
        self.window = window
        self.authService = authService
        self.tmdbService = tmdbService
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
        authService.isLoggedIn ? showMainApp() : showLoginPage()
    }
    
    func showMainApp() {
        guard let window = window else {
            return
        }
        
        let tabCoordinator = TabCoordinator(authService: authService, tmdbService: tmdbService, appCoordinator: self)
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
        
        let loginVC = LoginScreenAssembler.assemble(authService: authService, appCoordinator: self)
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.window?.rootViewController = loginVC
            }
        }
    }
}
