//
//  SetNicknameViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/4/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SetNicknameViewController: UIViewController {
    var viewModel: SetNicknameViewModel!
    
    lazy var upperTextLabel: UILabel = {
        let label = UILabel()
        label.text = "술,\n끊지 말고 잘 마시자"
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Ma실 준비가 되었나요?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        
        // Set placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: "닉네임",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ])
        
        // Set text color
        textField.textColor = .white
        
        // Set border
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 14
        textField.layer.borderWidth = 1
        textField.layer.borderColor = .hex("F8F8F8", alpha: 0.4)
        textField.layer.masksToBounds = true
        
        // Set view layouts
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.backgroundColor = .hex("C8C8C8", alpha: 0.3)
        return textField
    }()
    
    lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(didTapGetStartedButton),
            for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        setupViews()
        setupConstraints()
    }
}

// MARK: - Setup
private extension SetNicknameViewController {
    func setupViews() {
        view.addSubview(upperTextLabel)
        view.addSubview(mainTextLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(getStartedButton)
    }
    
    func setupConstraints() {
        upperTextLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalTo(upperTextLabel.snp.bottom).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
        
        getStartedButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
}

// MARK: - Actions
private extension SetNicknameViewController {
    @objc func didTapGetStartedButton() {
        guard let nickname = nicknameTextField.text else { return }
        Task {
            try await viewModel.setNickname(nickname)
        }
    }
}

import SwiftUI
#Preview {
    SetNicknameViewController.preview {
        let vc = SetNicknameViewController()
        vc.viewModel = SetNicknameViewModel(
            state: .init(
                platform: .apple,
                platformOAuthToken: "",
                accessToken: .init(nil)
            ))
        return vc
    }
}
