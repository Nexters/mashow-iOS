//
//  MashowRootViewController.swift
//  MashowKit
//
//  Created by Kai Lee on 7/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

class MashowRootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

import SwiftUI
#Preview {
    VStack {
        MashowRootViewController.preview()
        
        // or
        MashowRootViewController.preview {
            let vc = MashowRootViewController()
            
            vc.view.backgroundColor = .red
            return vc
        }
    }
}
