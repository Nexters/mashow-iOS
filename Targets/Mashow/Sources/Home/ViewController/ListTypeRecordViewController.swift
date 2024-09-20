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
    // MARK: - Properties
    private var nickname: String?
    private var userId: Int?
    private var availableDrinkTypes: [DrinkType] = []
    private var refreshHomeWhenSubmitted: @Sendable () async throws -> Void = {}
    
    func configure(
        nickname: String,
        userId: Int,
        availableDrinkTypes: [DrinkType],
        refreshHomeWhenSubmitted: @Sendable @escaping () async throws -> Void
    ) {
        self.nickname = nickname
        self.userId = userId
        self.availableDrinkTypes = availableDrinkTypes
        self.refreshHomeWhenSubmitted = refreshHomeWhenSubmitted
        
        updateCardViews()
    }
    
    // MARK: - UI Elements
    
    private lazy var cardViews: [MiniCardView] = createCardViews()
    
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
    
    // MARK: - Update Methods
    
    private func createCardViews() -> [MiniCardView] {
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
            if availableDrinkTypes.contains(drinkType) {
                cardView.configure(with: image, drinkType: drinkType, isSelected: true)
            } else {
                cardView.configure(with: image, drinkType: drinkType, isSelected: false)
            }
            
            // Enable tap gesture when the card view is selected
            if cardView.isSelected {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped(_:)))
                cardView.addGestureRecognizer(tapGesture)
                cardView.isUserInteractionEnabled = true
            }
            
            return cardView
        }
    }

    private func updateCardViews() {
        cardViews.forEach { $0.removeFromSuperview() } // Remove old card views
        cardViews = createCardViews() // Create new card views based on updated availableDrinkTypes

        // Rebuild the gridStackView with the updated card views
        gridStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for row in stride(from: 0, to: cardViews.count, by: 2) {
            let hStackView = UIStackView(arrangedSubviews: Array(cardViews[row..<min(row + 2, cardViews.count)]))
            hStackView.axis = .horizontal
            hStackView.distribution = .fillEqually
            hStackView.spacing = 10
            gridStackView.addArrangedSubview(hStackView)
        }
    }
    
    // MARK: - Action Handling
    
    @objc private func cardViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedCardView = sender.view as? MiniCardView,
              let drinkType = tappedCardView.drinkType,
              let nickname, let userId
        else {
            return
        }
        
        let vc = RecordListViewController(
            viewModel: .init(
                state: .init(
                    nickname: nickname, 
                    userId: userId,
                    fetchableDrinkTypes: availableDrinkTypes,
                    drinkTypeToBeShown: drinkType),
                action: .init(refreshHomeWhenSubmitted: { [weak self] in
                    guard let self else { return }
                    try await self.refreshHomeWhenSubmitted()
                })
            ))
        show(vc, sender: nil)
    }
}
