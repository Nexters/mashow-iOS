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
    
    // Closure to handle the tap action
    var onTap: (() -> Void)?
    
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
        setupTapGesture()
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
    
    private func setupTapGesture() {
        // Add tap gesture recognizer to the cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        // Trigger the onTap closure when the cell is tapped
        onTap?()
    }
    
    func configure(with records: [RecordListViewController.RecordCellInformation], onTap: @escaping () -> Void) {
        // Set the date for the first record, assuming the date is the same for all records in the cell
        if let firstRecord = records.first {
            dateLabel.text = firstRecord.date
        }
        
        // Set the closure for handling the tap action
        self.onTap = onTap
    }
}
