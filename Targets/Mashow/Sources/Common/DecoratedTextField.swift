//
//  DecoratedTextField.swift
//  Mashow
//
//  Created by Kai Lee on 8/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class DecoratedTextField: UITextField {
    
    var onDeleteButtonTapped: (() -> Void)?
    
    lazy var paddingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        return view
    }()

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
        self.clearButtonMode = .whileEditing
        self.setClearButton(
            with: UIImage(systemName: "xmark.circle.fill")!
                .withTintColor(.white.withAlphaComponent(0.3), renderingMode: .alwaysOriginal),
            mode: .whileEditing)
                
        // Set border
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.hex("555555", alpha: 0.4).cgColor
        self.layer.masksToBounds = true
        
        // Set padding view for text
        self.leftView = paddingView
        self.leftViewMode = .always
        self.backgroundColor = UIColor.hex("1B1F26", alpha: 0.7)
        
        // Add target for editing events
        self.addTarget(self, action: #selector(editingBegan), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingEnded), for: .editingDidEnd)
    }
    
    func reset() {
        self.leftView = paddingView
    }
    
    func showDeleteButtonIfNeeded() {
        if onDeleteButtonTapped != nil, let text, !text.isEmpty {
            setDeleteButton(
                with: UIImage(systemName: "minus.circle.fill")!
                    .withTintColor(.white.withAlphaComponent(0.3), renderingMode: .alwaysOriginal),
                mode: .always)
        }
    }
}

// MARK: - Actions

private extension DecoratedTextField {
    func setDeleteButton(with image: UIImage, mode: UITextField.ViewMode, padding: CGFloat = 14) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        // Create a container view for the clear button to add padding
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 24 + padding, height: 24))
        container.addSubview(clearButton)
        
        // Position the clear button within the container
        clearButton.frame = CGRect(x: padding, y: 0, width: 24, height: 24)
        
        // Set the container as the right view
        self.leftView = container
        self.leftViewMode = mode
    }
    
    @objc func didTapDeleteButton() {
        // Clear the text when the "-" button is tapped
        self.text = ""
        sendActions(for: .editingChanged)
        self.leftView = paddingView
        onDeleteButtonTapped?()
    }
    
    @objc func editingBegan() {
        // Change border color to white when editing begins
        self.layer.borderColor = .hex("818181")
        self.leftView = paddingView
    }
    
    @objc func editingEnded() {
        // Revert border color to the original color when editing ends
        self.layer.borderColor = UIColor.hex("555555", alpha: 0.4).cgColor
        showDeleteButtonIfNeeded()
    }
}

extension UITextField {
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode, padding: CGFloat = 14) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        
        // Create a container view for the clear button to add padding
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 24 + padding * 2, height: 24))
        container.addSubview(clearButton)
        
        // Position the clear button within the container
        clearButton.frame = CGRect(x: padding, y: 0, width: 24, height: 24)
        
        // Set the container as the right view
        self.rightView = container
        self.rightViewMode = mode
        
        // Ensure the clear button is displayed appropriately
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
    }
    
    @objc
    private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}
