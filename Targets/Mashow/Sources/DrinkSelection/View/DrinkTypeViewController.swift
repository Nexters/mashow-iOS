//
//  DrinkTypeViewController.swift
//  Mashow
//
//  Created by ZENA on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import Combine
import SnapKit

final class DrinkTypeViewController: UIViewController {
    
    let viewModel: DrinkSelectionViewModel!
    var drinkType: DrinkSelectionViewModel.DrinkType
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DrinkSelectionViewModel, drinkType: DrinkSelectionViewModel.DrinkType) {
        self.viewModel = viewModel
        self.drinkType = drinkType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var typeTitleImageView: UIImageView = {
        let image = UIImage(named: drinkType.rawValue)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var addDrinkTypeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 127, height: 40))
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .center
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .bold)
        var icon = UIImageView(image: UIImage(systemName: "plus"))
        
        button.backgroundColor = .white.withAlphaComponent(0.15)
        label.text = "주종 추가"
        label.textColor = .white.withAlphaComponent(0.7)
        icon.tintColor = .white.withAlphaComponent(0.7)
        view.addArrangedSubview(label)
        view.addArrangedSubview(icon)
        button.addSubview(view)
        view.bounds = button.bounds
        view.snp.makeConstraints { make in
            make.center.equalTo(button)
        }
        if viewModel.state.addedTypesPublisher.value.count >= 3 {
            button.isEnabled = false
            button.layer.opacity = 0.3
        }
        return button
    }()
    
    private lazy var addedDrinkTypeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 127, height: 40))
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .center
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .bold)
        var icon = UIImageView(image: UIImage(systemName: "plus"))
        
        let gradient = CAGradientLayer()
        gradient.frame = button.bounds
        gradient.colors = [
            UIColor.hex(drinkType.colorHexValues[0]).cgColor,
            UIColor.hex(drinkType.colorHexValues[1]).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        button.layer.insertSublayer(gradient, at: 0)
        label.text = "추가됨"
        label.textColor = UIColor.hex("434343")
        icon = UIImageView(image: UIImage(systemName: "checkmark"))
        icon.tintColor = UIColor.hex("434343")
        
        view.addArrangedSubview(label)
        view.addArrangedSubview(icon)
        button.addSubview(view)
        view.bounds = button.bounds
        view.snp.makeConstraints { make in
            make.center.equalTo(button)
        }
        button.isEnabled = false
        return button
    }()
    
    private lazy var drinkBottleImageView: UIImageView = {
        let image = UIImage(named: drinkType.rawValue + "Bottle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupLayouts()
        setupHandlers()
        viewModel.state.currentType.send(drinkType) // FIXME: - 드래그 조금만 해도 호출돼서 버그있음
    }
}

private extension DrinkTypeViewController {
    
    private func bind() {
        viewModel.state.addedTypesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addedTypes in
                guard let self = self else { return }
                let isTypeAdded = addedTypes.contains(self.drinkType)
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve) {
                    self.addDrinkTypeButton.isHidden = isTypeAdded
                    self.addedDrinkTypeButton.isHidden = !isTypeAdded
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupLayouts() {
        view.addSubview(typeTitleImageView)
        typeTitleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addDrinkTypeButton)
        addDrinkTypeButton.snp.makeConstraints { make in
            make.top.equalTo(typeTitleImageView.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        
        view.addSubview(addedDrinkTypeButton)
        addedDrinkTypeButton.snp.makeConstraints { make in
            make.top.equalTo(typeTitleImageView.snp_bottomMargin).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        addedDrinkTypeButton.isHidden = true
        
        view.addSubview(drinkBottleImageView)
        drinkBottleImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupHandlers() {
        addDrinkTypeButton.addTarget(self, action: #selector(addDrinkType), for: .touchUpInside)
    }
    
    @objc private func addDrinkType() {
        viewModel.addType(drinkType)
    }
}
