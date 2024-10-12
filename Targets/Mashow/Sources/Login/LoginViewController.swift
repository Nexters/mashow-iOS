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
        imageView.image = UIImage(resource: .backgroundDefault)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var logoImageView: UIStackView = {
        let stackView = UIStackView()
        var spacer: UIView { UIView() }
        
        let image = UIImage(resource: .logoBig)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(spacer)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        return stackView
    }()
    
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        
        // Set image for the button
        let buttonImage = UIImage(resource: .kakaoLogin)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill

        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .medium
        configuration.image = buttonImage
        configuration.imagePlacement = .all
        
        // Set corner radius
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        // Add target for button action
        button.addTarget(
            self,
            action: #selector(didTapSignInWithKakaoButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 12
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
        view.addSubview(logoImageView)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(kakaoLoginButton.snp.top)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
            make.leading.equalTo(view).inset(24)
            make.trailing.equalTo(view).inset(24)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-19)
            make.height.equalTo(60)
            make.leading.equalTo(view).inset(24)
            make.trailing.equalTo(view).inset(24)
        }
    }
}

// MARK: - Actions
private extension LoginViewController {
    @objc func didTapSignInWithAppleButton() {
        Task {
            do {
                let (oAuthToken, userInfo) = try await viewModel.signInWithApple()
                
                if let accessToken = userInfo?.accessToken {
                    // Login sucess. Report to publisher
                    viewModel.state.accessToken.send(accessToken)
                } else {
                    // User has never registered. Go to set nickname.
                    showSetNicknameViewController(platform: .apple, platformOAuthToken: oAuthToken)
                }
            } catch {
                // Show error alert
                showErrorAlert(message: "로그인 중 에러가 발생했습니다. 잠시후 다시 시도해주세요.")
                Environment.logger.errorMessage("🍺 Error signing in with Apple: \(error)")
            }
        }
    }
    
    @objc func didTapSignInWithKakaoButton() {
        Task {
            do {
                let (oAuthToken, userInfo) = try await viewModel.signInWithKakao()

                if let accessToken = userInfo?.accessToken {
                    // Login sucess. Report to publisher
                    viewModel.state.accessToken.send(accessToken)
                } else {
                    // User has never registered. Go to set nickname.
                    showSetNicknameViewController(platform: .kakao, platformOAuthToken: oAuthToken)
                }
            } catch {
                // Show error alert
                showErrorAlert(message: "로그인 중 에러가 발생했습니다. 잠시후 다시 시도해주세요.")
                Environment.logger.errorMessage("🍺 Error signing in with Kakao: \(error)")
            }
        }
    }
    
    private func showSetNicknameViewController(
        platform: AuthorizationManager.PlatformType,
        platformOAuthToken: String
    ) {
        let viewController = SetNicknameViewController()
        viewController.viewModel = SetNicknameViewModel(
            state: .init(
                platform: platform,
                platformOAuthToken: platformOAuthToken,
                accessToken: viewModel.state.accessToken
            ))
        
        show(viewController, sender: self)
    }
}

import SwiftUI
#Preview {
    LoginViewController.preview()
}
