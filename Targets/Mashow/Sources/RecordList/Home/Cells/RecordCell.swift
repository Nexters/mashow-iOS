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
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .hex("00FF00")
        return label
    }()
    
    lazy var typeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("타입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.hex("2F2F2F").withAlphaComponent(0.7)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
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
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, typeButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with record: RecordListViewController.Record) {
        dateLabel.text = record.date
        typeButton.setTitle(record.type, for: .normal)
    }
}
