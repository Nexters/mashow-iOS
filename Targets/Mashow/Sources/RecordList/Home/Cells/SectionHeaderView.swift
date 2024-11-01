//
//  SectionHeaderView.swift
//  Mashow
//
//  Created by Kai Lee on 8/29/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    private let countLabel = UILabel() // Label to show the count
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Configure title label
        titleLabel.font = .pretendard(size: 16, weight: .medium)
        titleLabel.textColor = .white
        
        // Configure count label
        countLabel.font = .pretendard(size: 16, weight: .medium)
        countLabel.textColor = .white.withAlphaComponent(0.4)

        // Create a horizontal stack view
        let stackView = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        addSubview(stackView)
        
        // Set up constraints for the stack view
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // Function to configure the header view with a title and count
    func configure(with title: String, count: Int) {
        countLabel.text = "\(count)"
        titleLabel.text = title
    }
}
