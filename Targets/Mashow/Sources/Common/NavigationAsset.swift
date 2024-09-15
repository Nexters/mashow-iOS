//
//  NavigationAsset.swift
//  Mashow
//
//  Created by Kai Lee on 9/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

struct NavigationAsset {
    static let backButtonImage = UIImage(systemName: "chevron.left",
                                         withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .bold))
    
    static func makeCancelButton(target: Any, _ didTapBackButton: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(
            title: "취소",
            style: .done,
            target: target,
            action: didTapBackButton
        )
        
        // Give alpha to text
        button.setTitleTextAttributes([
            .foregroundColor: UIColor.white.withAlphaComponent(0.5)
        ], for: .normal)
        
        return button
    }
    
    static func makeSaveButton(target: Any, _ didTapSaveButton: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: target,
            action: didTapSaveButton
        )
        
        // Give alpha to text
        button.setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .normal)
        
        return button
    }
}
