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
    }
    
    private func bind() {
        viewModel.state.accessToken
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accessToken in
                guard let self else { return }
                self.checkLoginStatus(with: accessToken)
                self.viewModel.saveTokenToStorage(accessToken: accessToken)
            }
            .store(in: &cancellables)
    }
    
    @MainActor private func checkLoginStatus(with accessToken: String?) {
        Task {
            // 로그인이 되어 있다면 accessToken이 존재한다
            if
                let accessToken,
                let user = await viewModel.validateUser(with: accessToken)
            {
                showMainViewController(with: user.nickname)
            } else {
                showLoginViewController()
            }
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
    
    private func showMainViewController(with nickname: String) {
        removeCurrentChildViewController()

        let homeViewController = HomeViewController()
        homeViewController.viewModel = HomeViewModel(
            state: .init(nickname: nickname,
                         accessToken: viewModel.state.accessToken))
        
        addChild(homeViewController)
        view.addSubview(homeViewController.view)
        homeViewController.view.frame = view.bounds
        
        homeViewController.didMove(toParent: self)
    }
}

import SwiftUI
#Preview {
    MashowRootViewController.preview()
}
