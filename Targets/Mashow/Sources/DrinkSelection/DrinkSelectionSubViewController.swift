//
//  DrinkSelectionSubViewController.swift
//  Mashow
//
//  Created by Kai Lee on 9/15/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class DrinkSelectionSubViewController: UIViewController {
    var environmentViewModel: DrinkSelectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Date.todayStringWrittenInKorean()
        navigationItem.leftBarButtonItem = NavigationAsset.makeCancelButton(target: self, #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = NavigationAsset.makeSaveButton(target: self, #selector(didTapSaveButton))
    }
}

private extension DrinkSelectionSubViewController {
    @objc private func didTapCancelButton() {
        environmentViewModel.flush()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        let vc = MemoViewController()
        vc.environmentViewModel = environmentViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
