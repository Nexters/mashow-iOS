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
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .emptyCard)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cardLabel: UILabel = {
        let label = UILabel()
        label.text = "SHOW\nme\nwhat you\ndrink!"
        label.font = .blankSans(size: 45, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionButton: CircularButton = {
        let button = CircularButton()
        button.setImage(
            UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .heavy)),
            for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.2)
        
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        return button
    }()
    
    lazy var actionButtonWrapperView: UIView = {
        let view = UIView()
        return view
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
        addSubview(actionButtonWrapperView)
        
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.centerX.equalToSuperview()
        }
        
        // To match center
        actionButtonWrapperView.snp.makeConstraints { make in
            make.top.equalTo(cardLabel.snp.bottom)
            make.centerX.equalTo(cardLabel)
            make.bottom.equalToSuperview()
        }
        
        actionButtonWrapperView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(56)
        }
    }
}

// MARK: - Actions
private extension CardView {
    @objc func didTapActionButton() {
        print("didTapActionButton")
    }
}
