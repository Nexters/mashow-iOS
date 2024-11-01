//
//  CapsuleShapeButton.swift
//  Mashow
//
//  Created by Kai Lee on 8/31/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class CapsuleShapeButton: UIButton {
    var customTitle: String! { didSet { configure() } }
    var customBackgroundColor: UIColor! { didSet { configure() } }
    var padding: NSDirectionalEdgeInsets! { didSet { configure() } }
    
    // Initializer for easy setup
    init(
        title: String,
        backgroundColor: UIColor = .hex("FCFCFC").withAlphaComponent(0.2),
        padding: NSDirectionalEdgeInsets = .init(top: 12, leading: 30, bottom: 12, trailing: 30)
    ) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        
        self.customTitle = title
        self.customBackgroundColor = backgroundColor
        self.padding = padding
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        configure()
    }
    
    private func configure() {
        var config = UIButton.Configuration.filled()
        
        if let currentTitle = self.title(for: .normal) {
            var attributedTitle = AttributedString(currentTitle)
            attributedTitle.font = .pretendard(size: 16, weight: .medium)
            config.attributedTitle = attributedTitle
        }
        
        config.cornerStyle = .capsule
        config.contentInsets = padding
        config.baseBackgroundColor = customBackgroundColor
        config.titleAlignment = .center
        
        // Apply the configuration
        self.configuration = config
        self.clipsToBounds = true
    }
}
