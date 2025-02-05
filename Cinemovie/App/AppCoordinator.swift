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
    
    init(window: UIWindow?, authService: AuthService) {
        self.window = window
        self.authService = authService
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
        
        let tabCoordinator = TabCoordinator(authService: authService, appCoordinator: self)
        tabCoordinator.start()
    
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                DispatchQueue.main.async {
                    window.rootViewController = tabCoordinator.tabBarController
                }
            }
        )
    }
    
    func showLoginPage() {
        guard let window = window else {
            return
        }
        
        let loginVC = LoginScreenAssembler.assemble(authService: authService, appCoordinator: self)
        
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                DispatchQueue.main.async {
                    window.rootViewController = loginVC
                }
            }
        )
    }
}
