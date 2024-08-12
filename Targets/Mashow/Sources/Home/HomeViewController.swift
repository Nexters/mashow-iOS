//
//  HomeViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/12/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class DrinkShowViewController: UIViewController {

    // MARK: - UI Elements

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .homeBackgroundDefault)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        label.font = .blackSans(size: 48, weight: .bold)
        label.textColor = .white
        return label
    }()

    lazy var showLabel: UILabel = {
        let label = UILabel()
        label.text = "SHOW"
        label.font = .blackSans(size: 48, weight: .bold)
        label.textColor = .white
        return label
    }()

    lazy var viewToggleStackView: ViewToggleStackView = {
        let view = ViewToggleStackView()
        return view
    }()

    lazy var drinkCardView: CardView = {
        let view = CardView()
        return view
    }()

    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기록하기", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 8
        return button
    }()

    lazy var experimentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .labIcon), for: .normal)
        button.tintColor = .white
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    // MARK: - View setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(showLabel)
        view.addSubview(viewToggleStackView)
        view.addSubview(drinkCardView)
        view.addSubview(recordButton)
        view.addSubview(experimentButton)
    }

    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view).offset(20)
        }

        showLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(-8)
            make.leading.equalTo(nicknameLabel)
        }

        experimentButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.trailing.equalTo(view).inset(20)
        }

        viewToggleStackView.snp.makeConstraints { make in
            make.top.equalTo(showLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(194)
            make.height.equalTo(34)
        }

        drinkCardView.snp.makeConstraints { make in
            make.top.equalTo(viewToggleStackView.snp.bottom).offset(16)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).inset(16)
        }

        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(50)
        }
    }
}

import SwiftUI
#Preview {
    DrinkShowViewController.preview()
}
