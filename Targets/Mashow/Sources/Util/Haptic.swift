//
//  Haptic.swift
//  Mashow
//
//  Created by Kai Lee on 10/7/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

struct Haptic {
    // Button tap feedback
    static private let buttonTapImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // Cancellation feedback
    static private let cancellationImpactGenerator = UISelectionFeedbackGenerator()
    
    // Notification feedback for success, warning, and error
    static private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    // Function for button tap
    static func buttonTap() {
        buttonTapImpactGenerator.prepare()
        buttonTapImpactGenerator.impactOccurred()
    }
    
    // Brrrrr...
    static func vibratingEffect() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
        for _ in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                generator.impactOccurred()
            }
        }
    }
    
    // Function for cancellation effect
    static func cancelSelection() {
        cancellationImpactGenerator.prepare()
        cancellationImpactGenerator.selectionChanged()
    }
    
    // Function for notification feedback (success, warning, error)
    static func notify(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(notificationType)
    }
}
