//
//  AppCoordinator.swift
//  Cinemovie
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow?
    private let container: DIContainer
    
    private var tabCoordinator: TabCoordinator?
    
    init(window: UIWindow?, container: DIContainer) {
        self.window = window
        self.container = container
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
        container.authService.isLoggedIn ? showMainApp() : showLoginPage()
    }
    
    private func showMainApp() {
        guard let window else { return }
        
        let tabCoordinator = TabCoordinator(diContainer: container, sessionDelegate: self)
        tabCoordinator.start()
        self.tabCoordinator = tabCoordinator
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = tabCoordinator.tabBarController
        }
    }
    
    private func showLoginPage() {
        guard let window else { return }
        
        let loginVC = LoginScreenAssembler.assemble(diContainer: container, sessionDelegate: self)
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = loginVC
        }
    }
}

// MARK: - SessionEndingDelegate
extension AppCoordinator: SessionDelegate {
    func didRequestLogIn() {
        self.showMainApp()
    }
    
    func didRequestLogOut() {
        container.authContext.clearSession()
        tabCoordinator = nil
        showLoginPage()
    }
}
