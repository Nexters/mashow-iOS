//
//  FoodCell.swift
//  Mashow
//
//  Created by Kai Lee on 8/10/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class FoodCell: UITableViewCell {
    static let identifier = "FoodCell"

    lazy var textField: UITextField = {
        let textField = DecoratedTextField()
        textField.placeholder = "이름 혹은 종류"
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(textField)
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(24)
        }
    }
    
    func configure(with text: String, tag: Int) {
        textField.text = text
        textField.tag = tag
    }
}
