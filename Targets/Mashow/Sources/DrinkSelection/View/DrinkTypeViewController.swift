//
//  DrinkTypeViewController.swift
//  Mashow
//
//  Created by ZENA on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

final class DrinkTypeViewController: UIViewController {
    
    let viewModel: DrinkSelectionViewModel!
    
    var drinkType: DrinkSelectionViewModel.DrinkType
    
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
        let button = UIButton()
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .center
        view.layer.cornerRadius = 50
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let label = UILabel()
        var icon = UIImageView(image: UIImage(systemName: "plus"))
        if let isAdded = viewModel.state.isTypeAdded[drinkType], isAdded {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.hex(drinkType.colorHexValues[0]), UIColor.hex(drinkType.colorHexValues[1])]
            view.layer.addSublayer(gradient)
            label.text = "추가됨"
            label.textColor = UIColor.hex("313131")
            icon = UIImageView(image: UIImage(systemName: "checkmark"))
            icon.tintColor = UIColor.hex("313131")
        } else {
            view.backgroundColor = .white.withAlphaComponent(0.15)
            label.text = "주종 추가"
            label.textColor = .white.withAlphaComponent(0.7)
            icon.tintColor = .white.withAlphaComponent(0.7)
        }
        // TODO: - 제약 맞추기
        view.addArrangedSubview(label)
        view.addArrangedSubview(icon)
        button.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 20),
            view.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 10)
        ])
        return button
    }()
    
    private lazy var drinkBottleImageView: UIImageView = {
        let image = UIImage(named: drinkType.rawValue + "Bottle")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.bounds = view.bounds
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayouts()
    }
}

private extension DrinkTypeViewController {
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "\(drinkType)_background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func setupLayouts() {
        view.addSubview(typeTitleImageView)
        typeTitleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeTitleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            typeTitleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        
        view.addSubview(addDrinkTypeButton)
        addDrinkTypeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addDrinkTypeButton.topAnchor.constraint(equalTo: typeTitleImageView.bottomAnchor, constant: 30),
            addDrinkTypeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(drinkBottleImageView)
        drinkBottleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkBottleImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            drinkBottleImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
    }
}
