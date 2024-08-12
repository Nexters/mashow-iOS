//
//  UIFont+Extension.swift
//  MashowKit
//
//  Created by ZENA on 8/6/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

extension UIFont {
    enum PretendardWeight: String {
        case black, bold, extraBold, extraLight, light, medium, regular, semibold, thin
    }
    
    static func pretendard(size fontSize: CGFloat, weight: UIFont.PretendardWeight) -> UIFont {
        return UIFont(name: "Pretendard-\(weight.rawValue)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
    }
}

extension UIFont {
    enum BlackSansWeight: String {
        case black, bold, extraBold, extraLight, light, medium, regular, semibold, thin
    }
    
    static func blackSans(size fontSize: CGFloat, weight: UIFont.BlackSansWeight) -> UIFont {
        return UIFont(name: "BlackSans-\(weight.rawValue)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
    }
}
