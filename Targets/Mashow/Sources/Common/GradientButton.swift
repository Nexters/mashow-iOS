//
//  GradientButton.swift
//  Mashow
//
//  Created by Kai Lee on 8/19/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    
    // Gradient layer
    private var gradientLayer: CAGradientLayer?
    
    // Colors for the gradient
    var gradientColors: [UIColor] = [] {
        didSet {
            setGradient()
        }
    }
    
    // Start and End points for the gradient (used differently for radial)
    var startPoint: CGPoint = .init(x: 0.0, y: 0.5) {
        didSet {
            setGradient()
        }
    }
    
    var endPoint: CGPoint = .init(x: 1.0, y: 0.5) {
        didSet {
            setGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setGradient(with: GradientButton.nextButtonColorSet)
    }
    
    private func setGradient(with colorSet: [UIColor] = GradientButton.nextButtonColorSet) {
        gradientLayer?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        // Configure the colors
        gradientLayer.colors = gradientColors.isEmpty ? colorSet.map(\.cgColor) : gradientColors.map(\.cgColor)
        
        // Set the locations for each color in the gradient
        gradientLayer.locations = [0.0, 0.5] as [NSNumber]
        
        // Set the start and end points
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // Configure the frame and corner radius
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

extension GradientButton {
    static var nextButtonColorSet: [UIColor] {
        return [.hex("F9FFF4"), .hex("FFCDCD"), .hex("F9FFF4")]
    }
}
