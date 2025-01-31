//
//  AppCoordinator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 31.01.2025.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = UIWindow()
    }
    
    func start() {
        let tabCoordinator = TabCoordinator()
        tabCoordinator.start()
        
        window?.rootViewController = tabCoordinator.tabBarController
        window?.makeKeyAndVisible()
    }
}
