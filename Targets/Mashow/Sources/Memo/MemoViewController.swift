//
//  MemoViewController.swift
//  MashowTests
//
//  Created by Kai Lee on 8/26/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class MemoViewController: DrinkSelectionSubViewController {
    private let viewModel: MemoViewModel = MemoViewModel()
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .backgroundDefault)
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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()

        registerForKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // Dismiss keyboard by swipe
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc override func didTapBackButton() {
        environmentViewModel.clearMemo()
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func didTapNextButton() {
        guard let text = memoTextView.text, validateMemo(text: text) else {
            return
        }
        
        environmentViewModel.saveMemo(DrinkDetail.Memo(description: text))
        Task {
            do {
                try await environmentViewModel.submit()
                viewModel.state.memo.send(text)
                navigationController?.popToRootViewController(animated: true)
            } catch {
                showErrorAlert(title: "네트워크 에러")
            }
        }
    }
}

// MARK: - Setup Methods

extension MemoViewController {
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(memoTextView)

        super.nextButton.setTitle("저장", for: .normal)
        view.addSubview(super.buttonStackView)
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
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
    }
}

extension MemoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Get the current text
        let currentText = textView.text ?? ""
        
        // Compute the proposed new text
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // Check if the updated text is valid
        return validateMemo(text: updatedText)
    }
    
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
        
        setNextButton(enabled: validateMemo(text: textView.text))
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
    
    func setNextButton(enabled: Bool) {
        nextButton.alpha = enabled ? 1 : 0.5
        nextButton.isEnabled = enabled
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
