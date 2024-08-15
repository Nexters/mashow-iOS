//
//  MashowRootViewController.swift
//  MashowKit
//
//  Created by Kai Lee on 7/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class MashowRootViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = MashowRootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        
        // Remove back button title("Back")
        navigationItem.backButtonTitle = ""
    }
    
    private func bind() {
        viewModel.state.accessToken
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accessToken in
                guard let self = self else { return }
                self.checkLoginStatus(with: accessToken)
                self.viewModel.saveTokenToStorage(accessToken: accessToken)
            }
            .store(in: &cancellables)
    }
    
    private func checkLoginStatus(with accessToken: String?) {
        // 로그인이 되어 있다면 accessToken이 존재한다
        if accessToken != nil {
            showMainViewController()
        } else {
            showLoginViewController()
        }
    }
    
    private func removeCurrentChildViewController() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    private func showLoginViewController() {
        removeCurrentChildViewController()

        let loginViewController = LoginViewController()
        addChild(loginViewController)
        
        view.addSubview(loginViewController.view)
        loginViewController.view.frame = view.bounds
        loginViewController.viewModel = LoginViewModel(
            state: .init(accessToken: viewModel.state.accessToken))
        
        loginViewController.didMove(toParent: self)
    }
    
    private func showMainViewController() {
        removeCurrentChildViewController()

        let mainViewController = HomeViewController()
        
        addChild(mainViewController)
        view.addSubview(mainViewController.view)
        mainViewController.view.frame = view.bounds
        
        mainViewController.didMove(toParent: self)
    }
}

import SwiftUI
#Preview {
    MashowRootViewController.preview()
}
