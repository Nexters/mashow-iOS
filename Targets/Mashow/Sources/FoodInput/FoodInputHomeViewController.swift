import UIKit
import SnapKit
import Combine

class FoodInputHomeViewController: UIViewController {
    private let viewModel = FoodInputHomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 음식으로 페어링을 했나요?"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var inputButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("안주 입력 +", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(didTapInputButton), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    lazy var foodItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.8)

        setupViews()
        setupConstraints()
        bind()
    }
}

// MARK: - View setup
private extension FoodInputHomeViewController {
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(inputButton)
        view.addSubview(foodItemsStackView)
        view.addSubview(saveButton)
        view.addSubview(backButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        inputButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        foodItemsStackView.snp.makeConstraints { make in
            make.top.equalTo(inputButton.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    func bind() {
        viewModel.state.foodItems
            .sink { [weak self] items in
                self?.updateFoodItemsStackView(with: items)
            }
            .store(in: &cancellables)
    }
    
    func updateFoodItemsStackView(with items: [String]) {
        // Clear previous views
        foodItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add new food items to the stack view
        for item in items {
            let label = UILabel()
            label.text = item
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16)
            foodItemsStackView.addArrangedSubview(label)
        }
    }
}

// MARK: - Actions
private extension FoodInputHomeViewController {
    @objc func didTapInputButton() {
        // Show modal view controller
        let foodInputViewController = FoodInputViewController()
        foodInputViewController.viewModel = FoodInputViewModel(
            action: .init(
                onSubmitResult: { [weak self] chosenFoods in
                    guard let self else { return }
                    self.viewModel.state.foodItems.send(chosenFoods)
                }))
        
        foodInputViewController.modalPresentationStyle = .fullScreen
        
        show(foodInputViewController, sender: nil)
    }
    
    @objc func didTapSaveButton() {
        // Handle save button tap action
    }
    
    @objc func didTapBackButton() {
        // Handle back button tap action
        navigationController?.popViewController(animated: true)
    }
}

import SwiftUI
#Preview {
    FoodInputHomeViewController.preview()
}
