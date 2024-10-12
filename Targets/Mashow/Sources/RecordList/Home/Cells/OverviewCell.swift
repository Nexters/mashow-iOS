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
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // Scroll view that wraps the button stack view
    private lazy var buttonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, 
                                               left: horizontalPadding,
                                               bottom: 0,
                                               right: horizontalPadding)
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
        buttonScrollView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(labelVstackView.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Set constraints for the button stack view within the scroll view
        buttonStack.snp.makeConstraints { make in
            make.edges.equalToSuperview() // superView == scrollView
            make.height.equalToSuperview()
        }
    }
}

// MARK: - Configuration

extension OverviewCell {
    func configure(title: String, drinkType: DrinkType, percentage: String, buttons: [RecordStat.Name]) {
        titleLabel.text = title
        percentageLabel.text = percentage
        
        configureConcentrationLabel(drinkType)
        
        // Remove existing buttons in the stack before adding new ones
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add the buttons to the buttonStack
        for buttonInfo in buttons {
            let button = createButton(title: buttonInfo.name, textColor: drinkType.themeColor, count: buttonInfo.count)
            buttonStack.addArrangedSubview(button)
        }
        
        if buttons.isEmpty {
            // Hide buttonScrollView and set height to 0 when no buttons are present
            buttonScrollView.isHidden = true
            buttonScrollView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            buttonScrollView.isHidden = false
            buttonScrollView.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
            
            // Update content size of the scroll view after adding buttons
            buttonScrollView.contentSize = CGSize(width: buttonStack.frame.width + horizontalPadding * 2,
                                                  height: buttonScrollView.frame.height)
        }
    }
    
    private func configureConcentrationLabel(_ drinkType: DrinkType) {
        // Create an attributed string for concentrationLabel
        let attributedText = NSMutableAttributedString(
            string: "혈중 " + drinkType.korean + " 농도",
            attributes: [.foregroundColor: UIColor.white]
        )
        
        // Apply different color to the second word
        let secondWordRange = (attributedText.string as NSString).range(of: drinkType.korean)
        attributedText.addAttribute(.foregroundColor, value: drinkType.themeColor, range: secondWordRange)
        concentrationLabel.attributedText = attributedText
    }
    
    private func createButton(title: String, textColor: UIColor, count: Int) -> UIButton {
        let button = UIButton(type: .system)
        
        // Create a horizontal stack to hold the title and the custom count label
        let hStack = UIStackView(arrangedSubviews: [
            createTitleLabel(with: title), createCountLabel(with: count, textColor: textColor)
        ])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 6
        
        // Set hugging priority for labels to ensure they don't stretch
        hStack.arrangedSubviews.forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        // Embed the stack view inside the button and set constraints
        button.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        // Set the background color and corner radius for the button
        button.backgroundColor = .hex("FCFCFC").withAlphaComponent(0.05)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        button.isUserInteractionEnabled = false
        return button
    }
    
    private func createTitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .pretendard(size: 16, weight: .regular)
        label.textColor = .white
        return label
    }
    
    private func createCountLabel(with count: Int, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = "\(count)"
        label.font = .pretendard(size: 16, weight: .bold)
        label.textColor = textColor
        return label
    }
}
