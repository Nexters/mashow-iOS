//
//  UIResponder+Extension.swift
//  Mashow
//
//  Created by Kai Lee on 9/28/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

extension UIResponder {
    private static weak var _currentFirstResponder: UIResponder?

    public static var currentFirstResponder: UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
