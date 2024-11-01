//
//  BlurredButton.swift
//  Mashow
//
//  Created by Kai Lee on 8/18/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class BlurredButton: UIButton {
    
    // The blur effect view is still initialized, with a default effect set to .dark
    private let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // The blur effect can be updated through this property, and it starts with .dark as default
    var blurEffect: UIBlurEffect = UIBlurEffect(style: .dark) {
        didSet {
            blurEffectView.effect = blurEffect
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up the blur effect view and button
        setupBlurEffectView()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Set up the blur effect view and button
        setupBlurEffectView()
        setupButton()
    }
    
    private func setupBlurEffectView() {
        blurEffectView.layer.cornerRadius = 13
        blurEffectView.clipsToBounds = true
        blurEffectView.isUserInteractionEnabled = false // Pass touches through

        // Add blur effect as a background view
        self.insertSubview(blurEffectView, at: 0)

        // Set up constraints for the blur effect view
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 13
        self.clipsToBounds = true
        self.backgroundColor = UIColor.hex("FCFCFC").withAlphaComponent(0.12)
    }
}
