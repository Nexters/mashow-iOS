//
//  DrinkTypeViewController.swift
//  Mashow
//
//  Created by ZENA on 8/5/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

final class DrinkTypeViewController: UIViewController {
    var drinkType: DrinkSelectionViewModel.DrinkType
    
    init(drinkType: DrinkSelectionViewModel.DrinkType) {
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
    
    private lazy var drinkBottleImageView: UIImageView = {
        // FIXME: needs default image
        let image = UIImage(named: drinkType.rawValue + "Bottle") // FIXME: 이거 에셋없
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.bounds = view.bounds
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
    }
}

private extension DrinkTypeViewController {
    private func setupLayouts() {
        view.addSubview(typeTitleImageView)
        view.addSubview(drinkBottleImageView)
        typeTitleImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkBottleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeTitleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            typeTitleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            drinkBottleImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            drinkBottleImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
