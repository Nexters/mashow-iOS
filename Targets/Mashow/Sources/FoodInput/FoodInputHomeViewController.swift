//
//  FoodSelectionViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/10/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class FoodInputHomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 음식으로 페어링을 했나요?"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var inputButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("안주 입력 +", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(didTapInputButton), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
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
private extension FoodInputHomeViewController {
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(inputButton)
        view.addSubview(saveButton)
        view.addSubview(backButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        inputButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}

// MARK: - Actions
private extension FoodInputHomeViewController {
    // Implement any button actions if necessary
    @objc func didTapInputButton() {
        // Show modal view controller
        let modalViewController = UIViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        modalViewController.view.backgroundColor = .gray
        
        show(modalViewController, sender: nil)
    }
    
    @objc func didTapSaveButton() {
        // Handle save button tap action
    }
    
    @objc func didTapBackButton() {
        // Handle back button tap action
        navigationController?.popViewController(animated: true)
    }
}

import SwiftUI
#Preview {
    FoodInputHomeViewController.preview()
}
