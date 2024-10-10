//
//  TipView.swift
//  Mashow
//
//  Created by Kai Lee on 10/10/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class TipView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendard(size: 16, weight: .semibold)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendard(size: 12, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let arrowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // Close button action handler
    var onClose: (() -> Void)?
    
    // Custom initializer to configure the title and message
    init(title: String, message: String, titleFont: UIFont? = nil, messageFont: UIFont? = nil) {
        super.init(frame: .zero)
        setupView(title: title, message: message, titleFont: titleFont, messageFont: messageFont)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(title: "", message: "")
    }
    
    private func setupView(title: String, message: String, titleFont: UIFont? = nil, messageFont: UIFont? = nil) {
        self.backgroundColor = .hex("2C2C2C").withAlphaComponent(0.8)
        self.layer.cornerRadius = 15
        
        titleLabel.text = title
        messageLabel.text = message
        
        // 폰트를 설정하는 부분 (선택적으로 제공된 경우)
        if let titleFont = titleFont {
            titleLabel.font = titleFont
        }
        if let messageFont = messageFont {
            messageLabel.font = messageFont
        }

        // Horizontal stack for title and close button
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 10
        titleStackView.alignment = .fill // fill로 설정하여 뷰 크기를 맞춤
        
        addSubview(titleStackView)
        addSubview(messageLabel)
        addSubview(arrowView)
        
        setupConstraints(titleStackView: titleStackView)
        closeButton.addTarget(self, action: #selector(dismissTip), for: .touchUpInside)
    }
    
    private func setupConstraints(titleStackView: UIStackView) {
        let commonVInset = 20
        let commonHInset = 15
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        
        // Title stack constraints
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(commonVInset)
            make.leading.equalToSuperview().offset(commonHInset)
            make.trailing.equalToSuperview().inset(commonHInset)
        }
        
        // Message label constraints
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(commonHInset)
            make.trailing.equalToSuperview().inset(commonHInset)
            make.bottom.equalToSuperview().inset(commonVInset)
        }

        // Arrow View Layout
        arrowView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.width.equalTo(20)
            make.height.equalTo(10)
        }
        
        // Draw arrow shape
        drawArrow()
    }
    
    private func drawArrow() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 10))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.hex("2C2C2C").withAlphaComponent(0.8).cgColor
        
        arrowView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // 이전에 그린 화살표 제거
        arrowView.layer.addSublayer(shapeLayer)
    }
    
    @objc private func dismissTip() {
        onClose?() // Trigger the closure when the close button is pressed
    }
}
