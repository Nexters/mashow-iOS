//
//  SceneDelegate.swift
//  Mashow
//
//  Created by Kai Lee on 7/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = MashowRootViewController()
        let viewController = UINavigationController(rootViewController: rootViewController)
        
        if let backImage = NavigationAsset.backButtonImage {
            viewController.navigationBar.backIndicatorImage = backImage
            viewController.navigationBar.backIndicatorTransitionMaskImage = backImage
        }
        
        // Set nav bar design
        viewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        viewController.navigationBar.tintColor = .white
        
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    // Handle universal link open
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach { context in
            let url = context.url.absoluteURL
            
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
