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
    enum BlankSansWeight: String {
        case bold
    }
    
    static func blankSans(size fontSize: CGFloat, weight: UIFont.BlankSansWeight) -> UIFont {
        return UIFont(name: "BlankSansOTF\(weight.rawValue)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .bold)
    }
}
