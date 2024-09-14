//
//  RecordCell.swift
//  Mashow
//
//  Created by Kai Lee on 8/29/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class RecordCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RecordCell"
    
    // Date label that remains at the top of the cell
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .roadRage(size: 24)
        label.textColor = .hex("63FFD0")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Give linear gradient to background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.hex("151515"), UIColor.hex("162B11")].map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with records: [RecordListViewController.Record]) {
        // Set the date for the first record, assuming the date is the same for all records in the cell
        if let firstRecord = records.first {
            dateLabel.text = firstRecord.date
        }
    }
}
