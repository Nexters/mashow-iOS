//
//  DecoratedTextField.swift
//  Mashow
//
//  Created by Kai Lee on 8/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import UIKit

class DecoratedTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        // Set placeholder
        self.attributedPlaceholder = NSAttributedString(
            string: "닉네임",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.hex("F3F3F3").withAlphaComponent(0.3)
            ])
        
        // Set text color
        self.textColor = .white
        
        // Set border
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.hex("555555", alpha: 0.4).cgColor
        self.layer.masksToBounds = true
        
        // Set padding view for text
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.backgroundColor = UIColor.hex("1B1F26", alpha: 0.7)
        
        // Additional configurations if needed
    }
}
