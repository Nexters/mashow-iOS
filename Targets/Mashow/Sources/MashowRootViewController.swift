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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupSignInWithApple()
    }
    
    private func setupSignInWithApple() {
        let signInWithAppleButton = ASAuthorizationAppleIDButton()
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
