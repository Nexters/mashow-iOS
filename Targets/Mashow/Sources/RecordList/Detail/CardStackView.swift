//
//  CardStackView.swift
//  Mashow
//
//  Created by Kai Lee on 9/2/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class CardStackView: UIView {
    
    // MARK: - Initializer
    
    init(cardImages: [UIImage]) {
        super.init(frame: .zero)
        setupCards(with: cardImages)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    func setupCards(with images: [UIImage]) {
        images.enumerated().reversed().forEach { index, image in
            let cardView = UIImageView()
            cardView.image = image
            cardView.contentMode = .scaleAspectFit
            
            addSubview(cardView)
            
            // Apply random rotation and translation to each card
            cardView.transform = if index == 0 {
                CGAffineTransform(rotationAngle: 0)
            } else {
                CGAffineTransform(
                    rotationAngle: CGFloat.random(in: 0.0...0.1) * CGFloat(index.isEven ? 1 : -1)
                )
                .translatedBy(x: CGFloat.random(in: -5...5), y: CGFloat.random(in: -5...5))
            }
            
            cardView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

fileprivate extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}
