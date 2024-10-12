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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .hex("FCFCFC").withAlphaComponent(0.05)

        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
        
        onTap?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func configure(with record: RecordListViewController.RecordCellInformation, onTap: @escaping () -> Void) {
        // Set the date for the first record, assuming the date is the same for all records in the cell
        if let date = record.date, let drinkType = record.drinkType {
            let formattedDateString = SharedDateFormatter.shortDateFormmater.string(from: date)

            dateLabel.text = formattedDateString
            dateLabel.textColor = drinkType.themeColor
        }
        
        // Set the closure for handling the tap action
        self.onTap = onTap
    }
}
