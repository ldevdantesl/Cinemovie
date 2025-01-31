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
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let splashVC = SplashScreenVC()
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showMainApp()
        }
    }
    
    private func showMainApp() {
        guard let window = window else {
            return
        }
        
        let tabCoordinator = TabCoordinator()
        tabCoordinator.start()
    
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = tabCoordinator.tabBarController
            },
            completion: { _ in
                window.makeKeyAndVisible()
            }
        )
    }
}
