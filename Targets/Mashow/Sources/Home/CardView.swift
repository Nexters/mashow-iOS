//
//  CardView.swift
//  Mashow
//
//  Created by Kai Lee on 8/12/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class CardView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .emptyCard)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cardLabel: UILabel = {
        let label = UILabel()
        label.text = "SHOW\nme\nwhat you\ndrink!"
        label.font = .blackSans(size: 45, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 25
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View setup
    
    private func setupViews() {
        addSubview(backgroundImageView)
        addSubview(cardLabel)
        addSubview(actionButton)
        
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.width.height.equalTo(50)
        }
    }
}
