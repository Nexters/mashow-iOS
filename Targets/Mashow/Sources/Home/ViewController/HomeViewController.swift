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
        label.font = .blankSans(size: 44, weight: .bold)
        label.textColor = .white
        return label
    }()

    lazy var showLabel: UILabel = {
        let label = UILabel()
        label.text = "SHOW"
        label.font = .blankSans(size: 44, weight: .bold)
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
    
    lazy var listTypeRecordViewController: ListTypeRecordViewController = {
        let view = ListTypeRecordViewController()
        return view
    }()
    
    lazy var recordButton: AddButton = {
        AddButton()
    }()

    lazy var myPageButton: CircularButton = {
        let button = CircularButton()
        button.setImage(
            UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)),
            for: .normal)
        button.tintColor = .white
        button.backgroundColor = .hex("F2F2F2").withAlphaComponent(0.3)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.width / 2

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupSubViewController()
        setupConstraints()
        setupSubViewAction()
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - View setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(showLabel)
        view.addSubview(viewToggleStackView)
//        view.addSubview(drinkCardView)
        view.addSubview(recordButton)
        view.addSubview(myPageButton)
    }
    
    private func setupSubViewController() {
        addChild(listTypeRecordViewController)
        view.addSubview(listTypeRecordViewController.view)
    }

    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view).offset(20)
        }
        nicknameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        showLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(view).offset(20)
        }
        showLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        viewToggleStackView.snp.makeConstraints { make in
            make.top.equalTo(showLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(194)
            make.height.equalTo(34)
        }
        
//        drinkCardView.snp.makeConstraints { make in
//            make.top.equalTo(viewToggleStackView.snp.bottom).offset(26)
//            make.leading.equalTo(view).offset(30)
//            make.trailing.equalTo(view).inset(30)
//            make.bottom.equalTo(recordButton.snp.top).offset(-20)
//        }
        
        listTypeRecordViewController.view.snp.makeConstraints { make in
            make.top.equalTo(viewToggleStackView.snp.bottom).offset(26)
            make.leading.equalTo(view).offset(24)
            make.trailing.equalTo(view).inset(24)
            make.bottom.equalTo(recordButton.snp.top).offset(-25)
        }
        
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        
        myPageButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.height.width.equalTo(32)
            make.trailing.equalTo(view).inset(20)
        }
    }
    
    func setupSubViewAction() {
        viewToggleStackView.onTapCardView = { [weak self] in
            self?.showAlert(title: "Coming Soon!", message: "곧 추가됩니다")
        }
    }
}

import SwiftUI
#Preview {
    HomeViewController.preview()
}
