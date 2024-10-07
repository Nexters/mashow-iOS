//
//  UIViewController+Alert.swift
//  Mashow
//
//  Created by Kai Lee on 8/7/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

extension UIViewController {
    // Default Alert
    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction] = []
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
        } else {
            for action in actions {
                alertController.addAction(action)
            }
        }
        present(alertController, animated: true, completion: nil)
    }

    // Error displaying Alert
    func showErrorAlert(
        title: String? = nil,
        message: String? = nil,
        onDismiss: @escaping () -> Void = {}
    ) {
        let alertController = UIAlertController(
            title: title ?? "에러",
            message: message ?? "에러가 발생했습니다. 잠시후 다시 시도해주세요.",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "OK", style: .default) { _ in
            onDismiss()
        }
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Confirm/Cancel Alert
    func showConfirmCancelAlert(
        title: String,
        message: String?,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            onConfirm()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Alert with Text Field
    func showAlertWithTextField(
        title: String,
        message: String,
        placeholder: String,
        onConfirm: @escaping (String?) -> Void,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소"
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            let text = alertController.textFields?.first?.text
            onConfirm(text)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Action Sheet
    func showActionSheet(
        title: String,
        message: String,
        actions: [UIAlertAction] = [],
        cancelTitle: String = "취소"
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
