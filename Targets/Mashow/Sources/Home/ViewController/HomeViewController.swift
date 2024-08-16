//
//  HomeViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/12/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

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
        label.font = .blankSans(size: 48, weight: .bold)
        label.textColor = .white
        return label
    }()

    lazy var showLabel: UILabel = {
        let label = UILabel()
        label.text = "SHOW"
        label.font = .blankSans(size: 48, weight: .bold)
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
        button.backgroundColor = .hex("151515").withAlphaComponent(0.3)
        button.layer.cornerRadius = 13
        button.clipsToBounds = true
        
        // Add blur to background
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = button.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.2
        button.addSubview(blurEffectView)
        
        return button
    }()

    lazy var myPageButton: CircularButton = {
        let button = CircularButton()
        button.setImage(
            UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)),
            for: .normal)
        button.tintColor = .white
        button.backgroundColor = .hex("F2F2F2").withAlphaComponent(0.3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.width/2

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
        view.addSubview(myPageButton)
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
            make.top.equalTo(nicknameLabel.snp.bottom).inset(8)
            make.leading.equalTo(nicknameLabel)
        }

        myPageButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.height.equalTo(32)
            make.width.equalTo(32)
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
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).inset(15)
            make.height.equalTo(60)
        }
    }
}

import SwiftUI
#Preview {
    HomeViewController.preview()
}

