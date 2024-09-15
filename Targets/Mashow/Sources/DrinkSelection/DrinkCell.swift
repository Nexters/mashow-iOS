//
//  DrinkCell.swift
//  Mashow
//
//  Created by Kai Lee on 9/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class DrinkCell: UITableViewCell {
    static let identifier = "DrinkCell"
    private var onTapDelete: (() -> Void)?
    
    var section: Int?
    var row: Int?

    lazy var textField: DecoratedTextField = {
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
    
    func configure(with text: String, section: Int, row: Int) {
        textField.text = text
        self.section = section
        self.row = row
    }
    
    func onTapDelete(_ onTapDelete: @escaping () -> Void) {
        self.onTapDelete = onTapDelete
        textField.onDeleteButtonTapped = onTapDelete
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.reset()
        section = nil
        row = nil
    }
}
