//
//  UIColor+Extension.swift
//  Mashow
//
//  Created by Kai Lee on 8/8/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

extension UIColor {
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count != 6 {
            return .white
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension CGColor {
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> CGColor {
        UIColor.hex(hex, alpha: alpha).cgColor
    }
}
