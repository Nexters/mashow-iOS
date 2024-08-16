//
//  CircularButton.swift
//  Mashow
//
//  Created by Kai Lee on 8/16/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // Ensure the button has equal width and height for a perfect circle
        self.layer.cornerRadius = self.frame.size.width / 2
        
        // Set background color
        self.backgroundColor = .systemBlue
        
        // Set title color
        self.setTitleColor(.white, for: .normal)
        
        // Ensure the button clips to its bounds
        self.clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update corner radius if frame changes
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
