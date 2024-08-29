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
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
