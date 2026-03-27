//
//  SceneDelegate.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    private let diContainer: DIContainer = DIContainer()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
        self.appCoordinator = AppCoordinator(window: window, networkService: diContainer.networkService, authService: diContainer.authService)
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        if url.scheme == "cinemovie" {
            NotificationCenter.default.post(name: Notification.Name(ConstantKeys.OAUTH_CALLBACK.rawValue), object: url)
        }
    }
}

