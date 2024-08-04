//
//  LoginViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/1/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import AuthenticationServices.ASAuthorizationAppleIDButton

class LoginViewController: UIViewController {
    var viewModel: LoginViewModel!
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "") // FIXME: Use the correct image name
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MA SHOW"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textAlignment = .center
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "술, 끊지 말고 잘 마시자"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.yellow
        button.setTitle("카카오로 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 8
        button.addTarget(
            self,
            action: #selector(didTapSignInWithKakaoButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(
            self,
            action: #selector(didTapSignInWithAppleButton),
            for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.8)

        setupViews()
        setupConstraints()
    }
}

// MARK: - View setup
private extension LoginViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(50)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-10)
            make.height.equalTo(50)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
    }
}

// MARK: - Actions
private extension LoginViewController {
    @objc func didTapSignInWithAppleButton() {
        Task {
            do {
                print(try await viewModel.signInWithApple())
            } catch {
                print(error)
            }
        }
    }
    
    @objc func didTapSignInWithKakaoButton() {
        Task {
            do {
                try await viewModel.signInWithKakao()
            } catch {
                print(error)
            }
        }
    }
}

import SwiftUI
#Preview {
    LoginViewController.preview()
}
