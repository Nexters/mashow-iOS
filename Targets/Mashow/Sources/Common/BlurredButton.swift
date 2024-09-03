//
//  BlurredButton.swift
//  Mashow
//
//  Created by Kai Lee on 8/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class BlurredButton: UIButton {

    private let blurEffectView: UIVisualEffectView
    
    override init(frame: CGRect) {
        // Initialize the blur effect with a light style
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(frame: frame)
        
        // Set up the blur effect view
        self.setupBlurEffectView()
        
        // Customize the button
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        // Initialize the blur effect with a light style
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(coder: coder)
        
        // Set up the blur effect view
        self.setupBlurEffectView()
        
        // Customize the button
        self.setupButton()
    }
    
    private func setupBlurEffectView() {
        blurEffectView.layer.cornerRadius = 13
        blurEffectView.clipsToBounds = true
        blurEffectView.isUserInteractionEnabled = false // Pass touches through
        
        // Add blur effect as a background view
        self.insertSubview(blurEffectView, at: 0)
        
        // Set up constraints for the blur effect view
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 13
        self.clipsToBounds = true
        self.backgroundColor = .hex("FCFCFC").withAlphaComponent(0.12)
    }
    
    // Method to update the blur effect style
    func updateBlurEffectStyle(_ style: UIBlurEffect.Style) {
        blurEffectView.effect = UIBlurEffect(style: style)
    }
}
