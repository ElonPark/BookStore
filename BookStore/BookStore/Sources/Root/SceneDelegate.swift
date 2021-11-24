//
//  SceneDelegate.swift
//  BookStore
//
//  Created by Elon on 2021/11/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        makeWindow(withWindowScene: scene)
    }
}

private extension SceneDelegate {
    func makeWindow(withWindowScene scene: UIWindowScene) {
        let rootComponent = RootComponent()
        let searchBuilder = rootComponent.searchBuilder
        let navigationController = BaseNavigationController(rootViewController: searchBuilder.build())

        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
