//
//  SceneDelegate.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}

