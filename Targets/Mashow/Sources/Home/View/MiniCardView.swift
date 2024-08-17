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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()    }

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
    }

    // MARK: - Configuration

    func configure(with image: UIImage?, drinkType: DrinkType) {
        backgroundImageView.image = image
    }
}
