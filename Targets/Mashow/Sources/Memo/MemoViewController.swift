//
//  MemoViewController.swift
//  MashowTests
//
//  Created by Kai Lee on 8/26/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class MemoViewController: UIViewController {
    var viewModel: MemoViewModel = MemoViewModel()
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground)
        imageView.contentMode = .scaleAspectFill
        
        // Add a dimming effect
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.5
        
        imageView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return imageView
    }()
    
    lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .pretendard(size: 16, weight: .semibold)
        textView.textColor = .white
        textView.textAlignment = .left
        textView.backgroundColor = UIColor.hex("2F2F2F").withAlphaComponent(0.7)
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 30, left: 16, bottom: 30, right: 16)
        
        // Add a listener for text changes to adjust height dynamically and manage placeholder visibility
        textView.delegate = self
        return textView
    }()

    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "자유롭게 메모해주세요"
        label.font = .pretendard(size: 16, weight: .semibold)
        label.textColor = UIColor.hex("F3F3F3").withAlphaComponent(0.3)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var previousButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("이전", for: .normal)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("저장하기", for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousButton, saveButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        registerForKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // Dismiss keyboard by swipe
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(buttonStackView)
        view.addSubview(memoTextView)
        
        setSaveButton(enabled: false)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        memoTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.greaterThanOrEqualTo(51)
            make.width.equalTo(310)
        }
        // Add the placeholder label to the text view
        memoTextView.addSubview(placeholderLabel)
        
        // Set constraints for the placeholder label
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.textContainerInset.top)
            make.leading.equalTo(memoTextView.textContainerInset.left + 5)
            make.trailing.equalTo(memoTextView.textContainerInset.right)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
}

extension MemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Show or hide the placeholder label
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // Determine the maximum height
        let maxHeight = 350.0
        
        // Adjust the text view's height dynamically
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height <= maxHeight {
            textView.isScrollEnabled = false
            textView.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(estimatedSize.height)
            }
        } else {
            textView.isScrollEnabled = true
            textView.snp.updateConstraints { make in
                make.height.greaterThanOrEqualTo(maxHeight)
            }
        }
        
        setLineHeight(for: textView, lineHeight: 8)
        
        setSaveButton(enabled: validateMemo(text: textView.text))
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        }
    }
}

// MARK: - Actions

private extension MemoViewController {
    @objc func didTapPreviousButton() {
    }
    
    @objc func didTapSaveButton() {
        guard let text = memoTextView.text, validateMemo(text: text) else { 
            return
        }
        
        viewModel.state.memo.send(text)
    }
}

// MARK: - Keyboard handling
private extension MemoViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            // Calculate the difference between the buttonStackView's bottom and the keyboard's top
            let bottomSpace = view.frame.height - (buttonStackView.frame.origin.y + buttonStackView.frame.height)
            let adjustmentHeight = keyboardHeight - bottomSpace + 20 // Adding a little padding
            
            if adjustmentHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.memoTextView.transform = CGAffineTransform(translationX: 0, y: -adjustmentHeight / 2)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.memoTextView.transform = .identity // Reset the transform to its original position
        }
    }
}

private extension MemoViewController {
    func validateMemo(text: String?) -> Bool {
        guard let text, !text.isEmpty, text.count <= 100 else {
            return false
        }
        
        return true
    }
    
    func setSaveButton(enabled: Bool) {
        saveButton.alpha = enabled ? 1 : 0.5
        saveButton.isEnabled = enabled
    }
    
    func setLineHeight(for textView: UITextView, lineHeight: CGFloat) {
        guard let font = textView.font else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight

        // Preserve the existing text with attributes, including font and other attributes
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)

        // Apply the paragraph style (line height) across the entire text
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        
        // Ensure the font is set consistently across the text
        attributedText.addAttribute(.font, value: font, range: NSMakeRange(0, attributedText.length))

        // Update the textView's attributedText with the new line height and preserved font
        textView.attributedText = attributedText
    }
}

import SwiftUI
#Preview {
    MemoViewController.preview()
}