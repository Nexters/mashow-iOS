//
//  DrinkSelectionViewController.swift
//  Mashow
//
//  Created by ZENA on 8/3/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

final class DrinkSelectionViewController: UIViewController {
    
    private let drinkTypeList = DrinkSelectionViewModel.DrinkType.allCases
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var bottomNextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.tintColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 13
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 13
        blurEffectView.layer.masksToBounds = true
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        button.insertSubview(blurEffectView, at: 0)
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: button.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigationBar()
        setupLayouts()
    }
}

private extension DrinkSelectionViewController {
    
    private func setupBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(resource: .backgroundDefault)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "7월 16일 화요일" // FIXME: set formmatted date string
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")!,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: nil // FIXME: set action
        )
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupLayouts() {
        pageViewController.setViewControllers(
            [DrinkTypeViewController(drinkType: drinkTypeList.first!)],
            direction: .forward,
            animated: false
        )
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.view.bounds = view.bounds
        pageViewController.dataSource = self
        pageViewController.didMove(toParent: self)
        
        view.addSubview(leftArrowButton)
        view.addSubview(rightArrowButton)
        view.addSubview(bottomNextButton)
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        bottomNextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftArrowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            rightArrowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            leftArrowButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            rightArrowButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            bottomNextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            bottomNextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomNextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomNextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

extension DrinkSelectionViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? DrinkTypeViewController else { return nil }
        guard var prevIndex = drinkTypeList.firstIndex(of: viewController.drinkType) else { return nil }
        prevIndex = prevIndex == 0 ? drinkTypeList.count - 1 : prevIndex - 1
        return DrinkTypeViewController(drinkType: drinkTypeList[prevIndex])
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? DrinkTypeViewController else { return nil }
        guard var nextIndex = drinkTypeList.firstIndex(of: viewController.drinkType) else { return nil }
        nextIndex = nextIndex == drinkTypeList.count - 1 ? 0 : nextIndex + 1
        return DrinkTypeViewController(drinkType: drinkTypeList[nextIndex])
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        return 0
    }
}
