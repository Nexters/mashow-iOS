//
//  DividerView.swift
//  MashowUI
//
//  Created by Kai Lee on 9/1/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class DividerView: UIView {
    
    // MARK: - Initializer
    
    init(color: UIColor = .lightGray, height: CGFloat = 1.0) {
        super.init(frame: .zero)
        self.backgroundColor = color
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
