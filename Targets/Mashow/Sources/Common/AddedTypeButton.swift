//
//  AddedTypeButton.swift
//  Mashow
//
//  Created by Kai Lee on 9/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine

final class AddedTypeButton: UIButton {
    // MARK: - Properties

    let drinkType: DrinkType

    // MARK: - UI Components

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = drinkType.korean
        label.font = .pretendard(size: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private lazy var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "xmark"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        return icon
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, icon])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Initializer

    init(type: DrinkType) {
        self.drinkType = type
        super.init(frame: .zero)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        var config = UIButton.Configuration.filled()
        
        if let currentTitle = self.title(for: .normal) {
            var attributedTitle = AttributedString(currentTitle)
            attributedTitle.font = .pretendard(size: 16, weight: .medium)
            config.attributedTitle = attributedTitle
        }
        
        config.cornerStyle = .capsule
//        config.contentInsets = .init(top: 6, leading: 17, bottom: 6, trailing: 17)
        config.baseBackgroundColor = .hex("151515").withAlphaComponent(0.5)
        config.titleAlignment = .center
        
        // Apply the configuration
        self.configuration = config
        self.clipsToBounds = true

        // Add subviews and set constraints
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-17)
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview().offset(-9)
        }
        
        stackView.isUserInteractionEnabled = false
    }
}
