//
//  ListTypeRecordViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ListTypeRecordViewController: UIViewController {
    // MARK: - UI Elements
    
    private lazy var cardViews: [MiniCardView] = {
        let drinks = DrinkType.allCases
        let images: [UIImage?] = [
            UIImage(resource: .sojuMinicard),
            UIImage(resource: .yangjuMinicard),
            UIImage(resource: .makgeoliMinicard),
            UIImage(resource: .sakeMinicard),
            UIImage(resource: .beerMinicard),
            UIImage(resource: .wineMinicard),
            UIImage(resource: .cocktailMinicard),
            UIImage(resource: .highballMinicard)
        ]
        
        return zip(drinks, images).map { drinkType, image in
            let cardView = MiniCardView()
            if drinkType == .soju {
                cardView.configure(with: image, drinkType: drinkType, isSelected: true)
            } else {
                cardView.configure(with: image, drinkType: drinkType, isSelected: false)
            }
            return cardView
        }
    }()
    
    private lazy var gridStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 10
        
        for row in stride(from: 0, to: cardViews.count, by: 2) {
            let hStackView = UIStackView(arrangedSubviews: Array(cardViews[row..<min(row + 2, cardViews.count)]))
            hStackView.axis = .horizontal
            hStackView.distribution = .fillEqually
            hStackView.spacing = 10
            vStackView.addArrangedSubview(hStackView)
        }
        
        return vStackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    // MARK: - View setup
    
    private func setupViews() {
        view.addSubview(gridStackView)
    }
    
    private func setupConstraints() {
        gridStackView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    // MARK: - Action Handling

    private func handleCardTap(for selectedCardView: MiniCardView) {
        selectedCardView.update(isSelected: !selectedCardView.isSelected)
    }
}

import SwiftUI
#Preview {
    ListTypeRecordViewController.preview()
}
