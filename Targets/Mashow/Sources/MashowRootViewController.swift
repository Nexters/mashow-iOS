//
//  MashowRootViewController.swift
//  MashowKit
//
//  Created by Kai Lee on 7/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import AuthenticationServices

class MashowRootViewController: UIViewController {
    
    let authManager = AuthorizationManager()
    lazy var signInWithAppleButton = ASAuthorizationAppleIDButton()
    lazy var button = UIButton(configuration: UIButton.Configuration.plain())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSignInWithApple()
        setupNavigationButton()
    }
    
    private func setupNavigationButton() {
        view.addSubview(button)
        button.setTitle("Drink Selection", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        button.addTarget(self, action: #selector(didTapNavButton), for: .touchUpInside)
    }
    
    @objc private func didTapNavButton() {
        navigationController?.pushViewController(DrinkSelectionViewController(), animated: true)
    }
    
    private func setupSignInWithApple() {
        signInWithAppleButton.addTarget(
            self,
            action: #selector(didTapSignInWithAppleButton),
            for: .touchUpInside
        )
        view.addSubview(signInWithAppleButton)
        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInWithAppleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapSignInWithAppleButton() {
        Task {
            try await authManager.signIn(with: .apple)
        }
    }
}

import SwiftUI
#Preview {
    VStack {
        MashowRootViewController.preview()
        
        // or
        MashowRootViewController.preview {
            let vc = MashowRootViewController()
            
            vc.view.backgroundColor = .red
            return vc
        }
    }
}
