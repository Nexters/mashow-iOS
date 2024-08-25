//
//  RulerView.swift
//  Mashow
//
//  Created by Kai Lee on 8/25/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class RulerView: UIView {
    var labels: [String] = [] // Array to store labels for highlighted ticks
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Clear any previous subviews
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // Calculate the spacing and setup the ruler
        let tickHeight: CGFloat = 8.0  // Height of the tick marks
        let tickSpacing: CGFloat = bounds.height / 20  // Spacing between ticks
        
        // Adjusted loop to ensure the bottommost tick is included
        for i in 0...20 {  // Use 0...20 to include the last tick
            let yPosition = CGFloat(i) * tickSpacing
            
            // Create an HStack for each tick and label pair
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .center
            hStack.spacing = 4  // Spacing between tick and label
            
            if i % 5 == 0, i / 5 < labels.count {
                // Add label for every 5th tick
                let label = UILabel()
                label.text = labels[i / 5]
                label.font = .pretendard(size: 16, weight: .semibold)
                label.textColor = .hex("909090")
                hStack.addArrangedSubview(label)
            }
            
            // Create the tick view
            let tickView = UIView()
            tickView.backgroundColor = (i % 5 == 0) ? UIColor.lightGray : UIColor.lightGray.withAlphaComponent(0.5)
            hStack.addArrangedSubview(tickView)
            
            if i % 5 == 0 {
                // Highlighted tick
                tickView.snp.makeConstraints { make in
                    make.width.equalTo(tickHeight)
                }
            } else {
                // Regular tick
                tickView.snp.makeConstraints { make in
                    make.width.equalTo(tickHeight / 2)
                }
            }
            tickView.snp.makeConstraints { make in
                make.height.equalTo(1)  // Set tick height (thickness)
            }
            
            // Add the hStack to the view
            addSubview(hStack)
            
            // Position the hStack using SnapKit
            hStack.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview().offset(yPosition - bounds.height / 2)
            }
        }
    }
}

