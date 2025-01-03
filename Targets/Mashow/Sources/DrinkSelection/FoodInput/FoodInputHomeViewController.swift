//  FoodInputHomeViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/4/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class FoodInputHomeViewController: DrinkSelectionSubViewController {
    private let viewModel = FoodInputHomeViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .backgroundDefault)
        imageView.contentMode = .scaleAspectFill
        
        // Add a dimming effect
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.5
        
        imageView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 음식으로\n페어링을 했나요?"
        label.font = .pretendard(size: 20, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var inputButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("안주 입력 +", for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .semibold)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.15)
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(didTapInputButton), for: .touchUpInside)
        return button
    }()
    
    lazy var foodItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var glassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .glass)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        setupNavigationBar()
        bind()
    }
    
    @objc override func didTapBackButton() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        environmentViewModel.clearSideDishes()
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func didTapNextButton() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        environmentViewModel.saveSideDishes(viewModel.state.foodItems.value)
        
        let vc = MemoViewController()
        vc.environmentViewModel = environmentViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc override func didTapSaveButton() {
        environmentViewModel.saveSideDishes(viewModel.state.foodItems.value)
        
        super.didTapSaveButton()
    }
}

// MARK: - View setup
private extension FoodInputHomeViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(inputButton)
        view.addSubview(foodItemsStackView)
        view.addSubview(glassImageView)
        view.addSubview(super.buttonStackView)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        inputButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.width.equalTo(124)
            make.height.equalTo(40)
        }
        
        foodItemsStackView.snp.makeConstraints { make in
            make.top.equalTo(inputButton.snp.bottom).offset(66)
            make.leading.trailing.equalTo(glassImageView)
            make.bottom.equalTo(glassImageView.snp.top).inset(-21)
        }
        
        glassImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
    }
    
    func bind() {
        viewModel.state.foodItems
            .sink { [weak self] foods in
                guard let self else { return }
                self.updateFoodItemsStackView(with: foods.map(\.title))
                self.environmentViewModel.saveSideDishes(foods)
            }
            .store(in: &cancellables)
    }
    
    func updateFoodItemsStackView(with items: [String]) {
        // Clear previous views
        foodItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let minimumItems = 3
        let emptyViewsCount = max(0, minimumItems - items.count)
        
        // Add empty views first
        for _ in 0..<emptyViewsCount {
            let emptyView = UIView()
            emptyView.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(90)
            }
            
            let arrangedView: UIStackView
            let paddingView = UIView()
            paddingView.snp.makeConstraints { make in
                make.width.equalTo(50)
            }
            
            arrangedView = UIStackView(arrangedSubviews: [emptyView, paddingView])
            foodItemsStackView.addArrangedSubview(arrangedView)
        }
        
        // Add actual food items to the stack view with animation
        for (index, item) in items.enumerated() {
            let button = GradientButton()
            button.gradientColors = GradientButton.nextButtonColorSet
            button.setTitle(item, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .pretendard(size: 16, weight: .bold)
            button.isEnabled = false
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(90)
            }
            
            let arrangedView: UIStackView
            let paddingView = UIView()
            paddingView.snp.makeConstraints { make in
                make.width.equalTo(50)
            }
            
            if (index + 1) % 2 == 0 {
                arrangedView = UIStackView(arrangedSubviews: [paddingView, button])
            } else {
                arrangedView = UIStackView(arrangedSubviews: [button, paddingView])
            }
            
            // Set initial position above the visible area
            arrangedView.alpha = 0
            arrangedView.transform = CGAffineTransform(translationX: 0, y: -50)
            foodItemsStackView.addArrangedSubview(arrangedView)
            
            // Animate with a delay for each item
            let delay = 0.5 * Double(items.count - index - 1) + 0.3
            UIView.animate(
                withDuration: 0.6,
                delay: delay,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.8,
                options: .curveEaseInOut,
                animations: {
                    arrangedView.alpha = 1
                    arrangedView.transform = .identity
                },
                completion: nil)
        }
    }
}

// MARK: - Actions
private extension FoodInputHomeViewController {
    @objc func didTapInputButton() {
        Haptic.buttonTap()
        
        // Show modal view controller
        let foodInputViewController = FoodInputViewController()
        foodInputViewController.viewModel = FoodInputViewModel(
            action: .init(
                onSubmitResult: { [weak self] chosenFoods in
                    guard let self else { return }
                    self.viewModel.state
                        .foodItems
                        .send(chosenFoods.map { DrinkDetail.SideDish(title: $0) })
                }))
        
        foodInputViewController.modalPresentationStyle = .fullScreen
        
        present(foodInputViewController, animated: true)
    }
}

import SwiftUI
#Preview {
    FoodInputHomeViewController.preview {
        let vc = FoodInputHomeViewController()
        vc.updateFoodItemsStackView(with: ["아메리카노", "카페라떼", "콜드브루"])
        return vc
    }
}
