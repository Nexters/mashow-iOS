//  SetNicknameViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/4/24.
//  © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SetNicknameViewController: UIViewController {
    var viewModel: SetNicknameViewModel!
    private let maxNicknameCount = 6
    private var currentNicknameCount = 0
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var upperTextLabel: UILabel = {
        let label = UILabel()
        label.text = "술,\n끊지 말고 잘 마시자"
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.font = .pretendard(size: 19, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Ma실 준비가 되었나요?"
        label.textColor = .white
        label.font = .pretendard(size: 20, weight: .bold)
        return label
    }()
    
    lazy var nicknameTextField: DecoratedTextField = {
        let textField = DecoratedTextField()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var textCountIndicatorView: UILabel = {
        let label = UILabel()
        label.text = "0/\(maxNicknameCount)"
        label.textColor = .hex("F3F3F3").withAlphaComponent(0.3)
        label.font = .pretendard(size: 18, weight: .regular)
        return label
    }()
    
    lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get started", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(didTapGetStartedButton),
            for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        setupViews()
        setupConstraints()
        setupTapToDismissKeyboard()
        updateSubmitButton(enabled: false)
    }
}

// MARK: - Setup
private extension SetNicknameViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(upperTextLabel)
        view.addSubview(mainTextLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(textCountIndicatorView)
        view.addSubview(getStartedButton)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        upperTextLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalTo(upperTextLabel.snp.bottom).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56)
        }
        
        textCountIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.right.equalTo(nicknameTextField).inset(10)
        }
        
        getStartedButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
    func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Delegate
extension SetNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text in the text field
        let currentText = textField.text ?? ""
        
        // Calculate the new length of the text after the change
        let newLength = currentText.count + string.count - range.length
        
        // Check if the new length is within the allowed range
        return newLength <= maxNicknameCount
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapGetStartedButton()
        return true
    }
}

// MARK: - Actions
private extension SetNicknameViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        currentNicknameCount = textField.text?.count ?? 0
        textCountIndicatorView.text = "\(currentNicknameCount)/\(maxNicknameCount)"
        
        if isNicknameValid(textField.text) {
            updateSubmitButton(enabled: true)
        } else {
            updateSubmitButton(enabled: false)
        }
    }
    
    @objc func didTapGetStartedButton() {
        guard
            let nickname = nicknameTextField.text,
            isNicknameValid(nickname)
        else {
            return
        }
        
        Task {
            do {
                let accessToken = try await viewModel.register(nickname: nickname)
                navigationController?.popViewController(animated: false)
                // Report to publisher
                viewModel.state.accessToken.send(accessToken)
            } catch {
                // Show error alert
                showErrorAlert()
                Environment.logger.errorMessage("🍺 Error setting nickname: \(error)")
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Utils
private extension SetNicknameViewController {
    func isNicknameValid(_ nickname: String?) -> Bool {
        func isAcceptable(_ input: String) -> Bool {
            // Define the regular expression pattern for allowed characters
            let pattern = "^[a-z0-9ㄱ-ㅣ가-힣]*$"
            
            // Create a regular expression object
            let regex = try! NSRegularExpression(pattern: pattern)
            
            // Check if the entire string matches the pattern
            let range = NSRange(location: 0, length: input.utf16.count)
            let match = regex.firstMatch(in: input, options: [], range: range)
            
            // Return true if a match is found, otherwise false
            return match != nil
        }
        
        guard let nickname = nickname, 1 <= nickname.count, nickname.count <= 6, isAcceptable(nickname) else {
            return false
        }
        
        return true
    }
    
    func updateSubmitButton(enabled: Bool) {
        getStartedButton.alpha = enabled ? 1 : 0.6
        getStartedButton.isEnabled = enabled ? true : false
    }
}

import SwiftUI
#Preview {
    SetNicknameViewController.preview {
        let vc = SetNicknameViewController()
        vc.viewModel = SetNicknameViewModel(
            state: .init(
                platform: .apple,
                platformOAuthToken: "",
                accessToken: .init(nil)
            ))
        return vc
    }
}
