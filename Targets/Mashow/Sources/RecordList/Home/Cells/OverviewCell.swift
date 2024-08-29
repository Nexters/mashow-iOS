//
//  OverviewCell.swift
//  Mashow
//
//  Created by Kai Lee on 8/29/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class OverviewCell: UICollectionViewCell {
    static let reuseIdentifier = "OverviewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MYUNG님의 이번달"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let concentrationLabel: UILabel = {
        let label = UILabel()
        label.text = "혈중 소주 농도"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .hex("00FF00")
        return label
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "41%"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, concentrationLabel, percentageLabel, buttonStack
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    // This is the configure method that allows injecting data from outside
    func configure(title: String, concentration: String, percentage: String, buttons: [(title: String, count: Int)]) {
        titleLabel.text = title
        concentrationLabel.text = concentration
        percentageLabel.text = percentage
        
        // Remove existing buttons in the stack before adding new ones
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add the buttons to the buttonStack
        for buttonInfo in buttons {
            let button = createButton(title: buttonInfo.title, count: buttonInfo.count)
            buttonStack.addArrangedSubview(button)
        }
    }
    
    private func createButton(title: String, count: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(title) \(count)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.hex("2F2F2F").withAlphaComponent(0.7)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
}
