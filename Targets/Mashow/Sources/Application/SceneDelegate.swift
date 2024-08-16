//
//  SceneDelegate.swift
//  Mashow
//
//  Created by Kai Lee on 7/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = MashowRootViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .systemBackground
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
