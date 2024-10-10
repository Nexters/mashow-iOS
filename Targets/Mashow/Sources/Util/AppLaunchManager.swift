//
//  AppLaunchManager.swift
//  Mashow
//
//  Created by Kai Lee on 10/10/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import StoreKit

class AppLaunchManager {
    private let launchCountKey = "launchCountKey"
    private let reviewRequestThreshold = 3

    func incrementLaunchCountAndRequestReviewIfNeeded() {
        let currentCount = UserDefaults.standard.integer(forKey: launchCountKey)
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: launchCountKey)
        
        if newCount >= reviewRequestThreshold {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.requestReview()
            }
        }
    }

    // 별점 요청 메서드
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
