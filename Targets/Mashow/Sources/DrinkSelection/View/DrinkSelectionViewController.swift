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
    
    init(viewModel: DrinkSelectionViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewModel: DrinkSelectionViewModel!
    private var cancellables = Set<AnyCancellable>()
    private let drinkTypeList = DrinkSelectionViewModel.DrinkType.allCases
    
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
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .bold)
        button.tintColor = .white
        button.layer.cornerRadius = 13
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
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
        bind()
        setupNavigationBar()
        setupLayouts()
        setupHandlers()
    }
}

private extension DrinkSelectionViewController {
    
    private func bind() {
        viewModel.state.currentType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentType in
                guard let self = self else { return }
                setupBackground(currentType.rawValue)
            }
            .store(in: &cancellables)
        
        viewModel.state.addedTypesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addedTypes in
                guard let self = self else { return }
                if let tag = self.removedButtonTag {
                    // If type removed
                    UIView.transition(with: addedTypesStackView, duration: 0.5, options: .transitionCrossDissolve) {
                        self.addedDrinkTypeButtons[tag]!.removeFromSuperview()
                        self.addedDrinkTypeButtons[tag] = nil
                        self.removedButtonTag = nil
                    }
                } else {
                    guard !addedTypes.isEmpty else { return }
                    // If type added
                    let newButton = self.makeAddedTypeButton()
                    newButton.addTarget(self, action: #selector(didTapToRemoveType), for: .touchUpInside)
                    self.addedDrinkTypeButtons[viewModel.state.currentType.value.tag] = newButton
                    UIView.transition(with: addedTypesStackView, duration: 0.5, options: .transitionCrossDissolve) {
                        self.addedTypesStackView.addArrangedSubview(newButton)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapToRemoveType(_ sender: UIButton) {
        removedButtonTag = sender.tag
        guard let index = drinkTypeList.firstIndex(where: { $0.tag == removedButtonTag }) else { return }
        viewModel.removeType(drinkTypeList[index])
    }
    
    private func makeAddedTypeButton() -> UIButton {
        let button = UIButton()
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        let label = UILabel()
        label.text = viewModel.state.currentType.value.korean
        label.font = .pretendard(size: 16, weight: .semibold)
        label.textColor = .white
        let icon = UIImageView(image: UIImage(systemName: "xmark"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        view.addArrangedSubview(label)
        view.addArrangedSubview(icon)
        button.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        button.backgroundColor = UIColor.hex("151515").withAlphaComponent(0.5)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.tag = viewModel.state.currentType.value.tag
        return button
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "7월 16일 화요일" // FIXME: set formmatted date string
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .done,
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
    
    private func setupBackground(_ currentType: String) {
        UIView.transition(with: backgroundView, duration: 0.5, options: .transitionCrossDissolve) {
            self.backgroundView.image = UIImage(named: "\(currentType)_background")
        }
    }
    
    private func setupLayouts() {
        backgroundView.contentMode = .scaleAspectFill
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [DrinkTypeViewController(viewModel: viewModel, drinkType: drinkTypeList.first!)],
            direction: .forward,
            animated: false
        )
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
            make.bottom.equalTo(view).offset(-30)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(56)
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
    
    @objc private func didTapLeftArrow() {
        pageViewController.moveToPrevPage()
    }
    
    @objc private func didTapRightArrow() {
        pageViewController.moveToNextPage()
    }
}

extension DrinkSelectionViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? DrinkTypeViewController else { return nil }
        guard var prevIndex = drinkTypeList.firstIndex(of: viewController.drinkType) else { return nil }
        prevIndex = prevIndex == 0 ? drinkTypeList.count - 1 : prevIndex - 1
        return DrinkTypeViewController(viewModel: viewModel, drinkType: drinkTypeList[prevIndex])
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? DrinkTypeViewController else { return nil }
        guard var nextIndex = drinkTypeList.firstIndex(of: viewController.drinkType) else { return nil }
        nextIndex = nextIndex == drinkTypeList.count - 1 ? 0 : nextIndex + 1
        return DrinkTypeViewController(viewModel: viewModel, drinkType: drinkTypeList[nextIndex])
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
