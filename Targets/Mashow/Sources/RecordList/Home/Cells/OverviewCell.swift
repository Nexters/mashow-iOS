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
    
    var horizontalPadding: CGFloat = 20
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let concentrationLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    // Stack view that holds the concentration and percentage labels
    private lazy var concentrationPercentageStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [concentrationLabel, percentageLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    // Stack view that holds the buttons
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // Scroll view that wraps the button stack view
    private lazy var buttonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        scrollView.addSubview(buttonStack)
        return scrollView
    }()
    
    // Main stack view that arranges the title, labels, and the scrollable button stack
    private lazy var labelVstackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, concentrationPercentageStack, spacer
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
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
        contentView.addSubview(labelVstackView)
        labelVstackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }
        
        contentView.addSubview(buttonScrollView)
        buttonScrollView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        buttonScrollView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        buttonScrollView.snp.makeConstraints { make in
            make.top.equalTo(labelVstackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Set constraints for the button stack view within the scroll view
        buttonStack.snp.makeConstraints { make in
            make.edges.equalToSuperview() // superView == scrollView
            make.height.equalToSuperview()
        }
    }
    
    // Configure method to set the data for the cell
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
        
        // Update content size of the scroll view after adding buttons
        buttonScrollView.contentSize = CGSize(width: buttonStack.frame.width + horizontalPadding * 2, height: buttonScrollView.frame.height)
    }
    
    private func createButton(title: String, count: Int) -> UIButton {
        let button = CapsuleShapeButton(title: "\(title) \(count)")
        button.padding = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        button.isUserInteractionEnabled = false
        return button
    }
}
