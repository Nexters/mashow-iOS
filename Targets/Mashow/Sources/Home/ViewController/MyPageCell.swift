//
//  MyPageCell.swift
//  Mashow
//
//  Created by Kai Lee on 9/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Custom UITableViewCell

class MyPageCell: UITableViewCell {
    static let identifier = "MyPageCell"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .regular)
        label.textColor = .label
        return label
    }()

    private var action: MyPageViewController.MyPageAction?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
        }
    }

    func configure(with item: MyPageViewController.MyPageItem) {
        titleLabel.text = item.title
        self.action = item.action

        accessoryView = nil
        accessoryType = item.accessoryType
    }
}
