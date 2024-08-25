//
//  RulerView.swift
//  Mashow
//
//  Created by Kai Lee on 8/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class RulerView: UIView {
    
    // MARK: - Properties
    
    var labels: [String] = [] // Array to store labels for highlighted ticks
    var labelImages: [UIImage] = [
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!,
        UIImage(systemName: "star.fill")!
    ] // Array to store label images for highlighted ticks
    
    private let tickCount = 20
    private let tickHeight: CGFloat = 8.0 // Height of the tick marks
    private var imageViewArray: [UIImageView] = [] // Store references to image views
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tickSpacing: CGFloat = bounds.height / 20 // Spacing between ticks
        
        // Clear any previous subviews and reset imageViewArray
        self.subviews.forEach { $0.removeFromSuperview() }
        
        createImageViewsIfNeeded()
        
        // Create and position hStacks for each tick and label pair
        for i in 0...tickCount {
            let yPosition = CGFloat(i) * tickSpacing
            let hStack = createHStack(for: i)
            
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

extension RulerView {
    // Enum to represent different levels
    enum Level {
        case one, two, three, four, five
    }
    
    // MARK: - Public Methods
    
    func triggerEvent(at level: Level) {
        switch level {
        case .one:
            highlightLevel(at: 0)
        case .two:
            highlightLevel(at: 1)
        case .three:
            highlightLevel(at: 2)
        case .four:
            highlightLevel(at: 3)
        case .five:
            highlightLevel(at: 4)
        }
    }
}


// MARK: - Private Methods

private extension RulerView {
    // Create image views if they haven't been created yet
    func createImageViewsIfNeeded() {
        guard imageViewArray.isEmpty else { return }
        
        imageViewArray = labelImages.map { image in
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true // Initially hidden
            return imageView
        }
    }
    
    // Highlight the image view at the specified index
    func highlightLevel(at index: Int) {
        createImageViewsIfNeeded()
        
        // Hide all images
        imageViewArray.forEach { $0.isHidden = true }
        
        // Unhide the image at the selected level
        if index < imageViewArray.count {
            imageViewArray[index].isHidden = false
        }
    } 
    
    func createHStack(for index: Int) -> UIStackView {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8 // Spacing between image, label, and tick
        
        // Add the image view if this is a highlighted tick
        if index % 5 == 0, index / 5 < labelImages.count {
            let imageView = imageViewArray[index / 5]
            hStack.addArrangedSubview(imageView)
            
            // Set constraints for the imageView
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(24) // Adjust size as needed
            }
        }
        
        // Add the label if this is a highlighted tick
        if index % 5 == 0, index / 5 < labels.count {
            let label = UILabel()
            label.text = labels[index / 5]
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.textColor = UIColor.hex("909090")
            hStack.addArrangedSubview(label)
        }
        
        // Create and add the tick view
        let tickView = UIView()
        tickView.backgroundColor = (index % 5 == 0) ? UIColor.lightGray : UIColor.lightGray.withAlphaComponent(0.5)
        hStack.addArrangedSubview(tickView)
        
        // Set constraints for the tick view
        tickView.snp.makeConstraints { make in
            make.width.equalTo(index % 5 == 0 ? tickHeight : tickHeight / 2)
            make.height.equalTo(1) // Set tick height (thickness)
        }
        
        return hStack
    }
}
