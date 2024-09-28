//
//  DrinkSelectionViewController.swift
//  Mashow
//
//  Created by ZENA on 8/3/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import Combine
import SnapKit

final class DrinkSelectionViewController: UIViewController {
    // Default initial type is Soju
    init(viewModel: DrinkSelectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewModel: DrinkSelectionViewModel
    private var cancellables = Set<AnyCancellable>()
    private let drinkTypeList = DrinkType.allCases
    
    private var removedButtonTag: Int?
    typealias TypeButtonTag = Int
    private var addedDrinkTypeButtons = [TypeButtonTag: UIButton]()
    
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
    
    var backgroundView = UIImageView()
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var addedTypesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private lazy var bottomNextButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .bold)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex("151515") // Prevent weird transition
        
        bind()
        setupNavigationBar()
        setupLayouts()
        setupHandlers()
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
}

extension DrinkSelectionViewController {
    
    private func bind() {
        viewModel.state.addedTypes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addedTypes in
                guard let self else { return }

                self.addedTypesStackView.subviews.forEach { $0.removeFromSuperview() }
                addedTypes.forEach { type in
                    let newButton = AddedTypeButton(type: type)
                    newButton.addTarget(self, action: #selector(self.onTapAddedTypeButton), for: .touchUpInside)
                    self.addedTypesStackView.addArrangedSubview(newButton)
                }
                
                if addedTypes.isEmpty == true {
                    bottomNextButton.alpha = 0.5
                    bottomNextButton.isEnabled = false
                    setupNavigationBar()
                } else {
                    bottomNextButton.alpha = 1
                    bottomNextButton.isEnabled = true
                    setupNavigationBar()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func onTapAddedTypeButton(_ sender: UIButton) {
        guard let sender = sender as? AddedTypeButton else {
            return
        }
        
        let typeToBeRemoved = sender.drinkType
        viewModel.removeType(typeToBeRemoved)
    }
    
    private func setupNavigationBar() {        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = Date.todayStringWrittenInKorean()
        navigationItem.leftBarButtonItem = NavigationAsset.makeCancelButton(target: self, #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = NavigationAsset.makeSaveButton(target: self, 
                                                                           isEnabled: currentlySubmittable,
                                                                           #selector(didTapSaveButton))
    }
    
    private func setupBackground(to type: DrinkType) {
        UIView.transition(with: backgroundView, duration: 0.5, options: .transitionCrossDissolve) {
            self.backgroundView.image = UIImage(named: "\(type.rawValue)_background")
        }
    }
    
    private func setupLayouts() {
        view.addSubview(backgroundView)
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        if let initialType = viewModel.state.initialDrinkType {
            setupBackground(to: initialType)
            pageViewController.setViewControllers(
                [DrinkTypeViewController(viewModel: viewModel, drinkType: initialType)],
                direction: .forward,
                animated: false
            )
        } else {
            let defaultType = DrinkType.soju
            setupBackground(to: defaultType)
            pageViewController.setViewControllers(
                [DrinkTypeViewController(viewModel: viewModel, drinkType: defaultType)],
                direction: .forward,
                animated: false
            )
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.backgroundColor = .clear
        
        view.addSubview(leftArrowButton)
        leftArrowButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        view.addSubview(rightArrowButton)
        rightArrowButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        view.addSubview(bottomNextButton)
        bottomNextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
        
        view.addSubview(addedTypesStackView)
        addedTypesStackView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomNextButton.snp_topMargin).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupHandlers() {
        leftArrowButton.addTarget(self, action: #selector(didTapLeftArrow), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(didTapRightArrow), for: .touchUpInside)
    }
}

// MARK: - Actions
extension DrinkSelectionViewController {
    @objc private func didTapLeftArrow() {
        pageViewController.moveToPrevPage()
        
        if let shownVC = pageViewController.viewControllers?.first as? DrinkTypeViewController {
            setupBackground(to: shownVC.drinkType)
        }
    }
    
    @objc private func didTapRightArrow() {
        pageViewController.moveToNextPage()
        
        if let shownVC = pageViewController.viewControllers?.first as? DrinkTypeViewController {
            setupBackground(to: shownVC.drinkType)
        }
    }
    
    @objc private func didTapNextButton() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        guard currentlySubmittable else {
            return
        }
        
        let vc = DrinkDetailViewController()
        vc.environmentViewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapCancelButton() {
        viewModel.flush()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        Task {
            do {
                if currentlySubmittable {
                    try await viewModel.submit()
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                showErrorAlert()
            }
        }
    }
    
    private var currentlySubmittable: Bool {
        guard viewModel.state.addedTypes.value.isEmpty == false else {
            return false
        }
        
        return true
    }
}

extension DrinkSelectionViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let viewControllers = pendingViewControllers.compactMap({ $0 as? DrinkTypeViewController })
        guard let currentType = viewControllers.first?.drinkType else {
            return
        }
        
        setupBackground(to: currentType)
    }
    
    // Goto previous page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let viewController = viewController as? DrinkTypeViewController,
            let currentIndex = drinkTypeList.firstIndex(of: viewController.drinkType)
        else {
            return nil
        }
        
        let indexToGo = currentIndex == 0 ? drinkTypeList.endIndex - 1 : currentIndex - 1
        let drinkTypeToGo = drinkTypeList[indexToGo]
        
        return DrinkTypeViewController(viewModel: viewModel, drinkType: drinkTypeToGo)
    }

    // Goto next page
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let viewController = viewController as? DrinkTypeViewController,
            let currentIndex = drinkTypeList.firstIndex(of: viewController.drinkType)
        else {
            return nil
        }
        
        // Skip if the received vc is not current vc
        
        let indexToGo = currentIndex == drinkTypeList.endIndex - 1 ? 0 : currentIndex + 1
        let drinkTypeToGo = drinkTypeList[indexToGo]
        
        print(indexToGo, drinkTypeToGo)
        
        return DrinkTypeViewController(viewModel: viewModel, drinkType: drinkTypeToGo)
    }
}

extension UIPageViewController {
    func moveToNextPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true)
    }
    
    func moveToPrevPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: true)
    }
}
