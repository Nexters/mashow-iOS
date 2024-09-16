//
//  DrinkSelectionSubViewController.swift
//  Mashow
//
//  Created by Kai Lee on 9/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class DrinkSelectionSubViewController: UIViewController {
    var environmentViewModel: DrinkSelectionViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        bindLoadingView()
    }
    
    // MARK: - Properties
    
    lazy var nextButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = BlurredButton()
        button.blurEffect = UIBlurEffect(style: .light)
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, nextButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.color = .white
        loadingView.startAnimating()
        return loadingView
    }()
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Date.todayStringWrittenInKorean()
        navigationItem.leftBarButtonItem = NavigationAsset.makeCancelButton(target: self, #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = NavigationAsset.makeSaveButton(target: self, #selector(didTapSaveButton))
    }
    
    func bindLoadingView() {
        environmentViewModel.state.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingView.isHidden = false
                } else {
                    self.loadingView.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Overridable actions
    
    @objc private func didTapCancelButton() {
        environmentViewModel.flush()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        Task {
            do {
                try await environmentViewModel.submit()
                navigationController?.popToRootViewController(animated: true)
            } catch {
                showErrorAlert(title: "네트워크 에러")
            }
        }
    }
    
    @objc func didTapBackButton() {
        fatalError("It should be implemented in subclass")
    }
    
    @objc func didTapNextButton() {
        fatalError("It should be implemented in subclass")
    }
}
