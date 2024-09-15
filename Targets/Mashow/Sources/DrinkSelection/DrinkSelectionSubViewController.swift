//
//  DrinkSelectionSubViewController.swift
//  Mashow
//
//  Created by Kai Lee on 9/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class DrinkSelectionSubViewController: UIViewController {
    var environmentViewModel: DrinkSelectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
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
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Date.todayStringWrittenInKorean()
        navigationItem.leftBarButtonItem = NavigationAsset.makeCancelButton(target: self, #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = NavigationAsset.makeSaveButton(target: self, #selector(didTapSaveButton))
    }
    
    
    // MARK: - Overridable actions
    
    @objc private func didTapCancelButton() {
        environmentViewModel.flush()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        environmentViewModel.saveRecord()
        // FIXME: Maybe need to wait server response
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func didTapBackButton() {
        fatalError("It should be implemented in subclass")
    }
    
    @objc func didTapNextButton() {
        fatalError("It should be implemented in subclass")
    }
}
