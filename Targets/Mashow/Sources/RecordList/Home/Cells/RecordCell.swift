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
        label.textColor = .hex("00FF00")
        return label
    }()
    
    // Stack view that holds the type buttons
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing // Ensures elements keep their intrinsic height
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
        backgroundColor = UIColor.hex("2F2F2F").withAlphaComponent(0.7)
        layer.cornerRadius = 10
        
        addSubview(dateLabel)
        addSubview(stackView)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with records: [RecordListViewController.Record]) {
        // Set the date for the first record, assuming the date is the same for all records in the cell
        if let firstRecord = records.first {
            dateLabel.text = firstRecord.date
        }
        
        // Clear the stack view before adding new content
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var spacer: UIView { UIView() }
        
        for record in records {
            // Create and configure type button
            let typeButton = CapsuleShapeButton(title: record.type ?? "")
            typeButton.isUserInteractionEnabled = false
            
            // Ensure the button keeps its intrinsic height
            typeButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
            typeButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
            
            // Add button to the stack view
            stackView.addArrangedSubview(typeButton)
        }
        
        stackView.addArrangedSubview(spacer)
    }
}
