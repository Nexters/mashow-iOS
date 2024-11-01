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
    private(set) var drinkType: DrinkType?
    
    // MARK: - UI Elements

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // Closure to handle tap events
    var isSelected: Bool = false
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
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

    // MARK: - Opacity and Transform (For touch effects)

    func setPressedState() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func setReleasedState() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }

    // 터치 이벤트 처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setPressedState()  // 손가락이 눌렸을 때 애니메이션
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setReleasedState()  // 손가락이 떼졌을 때 애니메이션
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setReleasedState()  // 터치가 취소될 때 애니메이션
    }
    
    // MARK: - Opacity Control

    func setOpacity(to alpha: CGFloat) {
        self.alpha = alpha
    }
}

// MARK: - Configuration
extension MiniCardView {
    func configure(with image: UIImage?, drinkType: DrinkType, isSelected: Bool = false) {
        self.drinkType = drinkType
        backgroundImageView.image = image
        update(isSelected: isSelected)
    }
    
    func update(isSelected: Bool) {
        self.isSelected = isSelected
        setOpacity(to: isSelected ? 1.0 : 0.2)
    }
}
