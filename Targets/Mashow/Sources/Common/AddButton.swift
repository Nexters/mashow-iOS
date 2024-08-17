//
//  AddButton.swift
//  Mashow
//
//  Created by Kai Lee on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    // MARK: - Properties
    var onTap: (() -> Void)?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup Method

    private func setupButton() {
        // Ensure the button has equal width and height for a perfect circle
        self.layer.cornerRadius = self.frame.size.width / 2
        
        // Set background color
        self.backgroundColor = .black.withAlphaComponent(0.2)
        
        // Set the image for the button
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .heavy)
        let plusImage = UIImage(systemName: "plus", withConfiguration: configuration)
        self.setImage(plusImage, for: .normal)
        
        // Set image tint color
        self.tintColor = .white
        
        // Ensure the button clips to its bounds
        self.clipsToBounds = true
        
        // Add target for button action
        self.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    // MARK: - Action Method
    
    @objc
    private func didTapAddButton() {
        onTap?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update corner radius if frame changes
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
