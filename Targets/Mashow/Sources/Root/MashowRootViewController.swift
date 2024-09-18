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
        
        bind()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Properties
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .homeBackgroundDefault)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - setup
    
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
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Utils
    
    @MainActor private func checkLoginStatus(with accessToken: String?) {
        Task {
            // 로그인이 되어 있다면 accessToken이 존재한다
            guard let accessToken else {
                showLoginViewController()
                return
            }
            
            do {
                let user = try await self.viewModel.validateUser(with: accessToken)
                showMainViewController(with: user.nickname)
            } catch {
                showErrorAlert(message: "로그인 중 에러가 발생했습니다.\n다시 로그인해주세요.")
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
        navigationController?.popToRootViewController(animated: false)
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
        navigationController?.popToRootViewController(animated: false)
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
