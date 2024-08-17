//
//  MiniCardView.swift
//  Mashow
//
//  Created by Kai Lee on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class MiniCardView: UIView {
    // MARK: - UI Elements

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // Closure to handle tap events
    var onTap: (() -> Void)?
    var isSelected: Bool = false
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup

    private func setupViews() {
        addSubview(backgroundImageView)
    }

    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
        }
        backgroundImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        backgroundImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    // MARK: - Opacity Control

    func setOpacity(to alpha: CGFloat) {
        self.alpha = alpha
    }
}

// MARK: - Configuration
extension MiniCardView {
    func configure(with image: UIImage?, drinkType: DrinkType, isSelected: Bool = false) {
        backgroundImageView.image = image
        update(isSelected: isSelected)
    }
    
    func update(isSelected: Bool) {
        self.isSelected = isSelected
        setOpacity(to: isSelected ? 1.0 : 0.3)
    }
}
