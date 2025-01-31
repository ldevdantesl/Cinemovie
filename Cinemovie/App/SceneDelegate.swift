//
//  SceneDelegate.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: SplashScreenAssembler.assemble())
        window?.makeKeyAndVisible()
    }

    // MARK: - PRIVATE FUNCTIONS
    private func setupTabBar() -> UITabBarController {
        let tabbar = UITabBarController()
        
        let homeVC = HomeScreenAssembler.assemble()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "mail.stack"),
            tag: 0
        )
        
        let searchVC = SearchScreenAssembler.assemble()
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        
        let settingsVC = SettingsScreenAssembler.assemble()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 2
        )
        
        tabbar.viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: settingsVC)
        ]
        
        return tabbar
    }
}

