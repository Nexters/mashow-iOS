//
//  FoodInputViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/10/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class FoodInputViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: FoodInputViewModel!
    private var foodItems: [String] = [""]
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground)
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
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "먹은 음식 이름 또는 종류를\n적어주세요!"
        label.font = .pretendard(size: 20, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.identifier)
        tableView.separatorStyle = .none
        
        // Enable automatic dimension for cell height
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    lazy var addFooterView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("+ 추가하기", for: .normal)
        addButton.titleLabel?.font = .pretendard(size: 14, weight: .regular)
        addButton.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        footerView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerX.equalTo(footerView)
            make.top.equalTo(footerView)
        }
        
        return footerView
    }()
    
    lazy var nextButton: UIButton = {
        let button = GradientButton()
        button.gradientColors = GradientButton.nextButtonColorSet
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .medium)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupViews()
        setupConstraints()
        setupTableFooter()
    }
}

// MARK: - View setup
private extension FoodInputViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(nextButton)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(16)
            make.top.equalTo(dismissButton.snp.bottom).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view).inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupTableFooter() {
        addFooterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableFooterView = addFooterView
        updateFooterVisibility() // Initial check
        updateDoneButtonEnability() // Initial check
    }
    
    func updateFooterVisibility() {
        // Hide the footer view if there are more than 3 items
        if foodItems.count > 2 {
            tableView.tableFooterView?.isHidden = true
        } else {
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    func updateDoneButtonEnability() {
        nextButton.isEnabled = isResultSubmittable(result: foodItems)
        nextButton.alpha = nextButton.isEnabled ? 1.0 : 0.5
    }
}

// MARK: - Actions
private extension FoodInputViewController {
    @objc func didTapAddButton() {
        foodItems.append("")
        tableView.reloadData()
        updateFooterVisibility()
    }
    
    @objc func didTapNextButton() {
        let chosenFoods = foodItems.filter { !$0.isEmpty }
        viewModel.submitResult(chosenFoods: chosenFoods)
        dismiss(animated: true)
    }
    
    @objc func didTapDismissButton() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FoodInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.identifier, for: indexPath) as? FoodCell else {
            return UITableViewCell()
        }
        cell.configure(with: foodItems[indexPath.row], tag: indexPath.row)
        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.onTapDelete { [weak self] in
            self?.foodItems.remove(at: indexPath.row)
            self?.tableView.reloadData()
            self?.updateFooterVisibility()
            self?.updateDoneButtonEnability()
        }
        // To fix buggy reused cells
        cell.textField.showDeleteButtonIfNeeded()
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        foodItems[textField.tag] = textField.text ?? ""
        updateFooterVisibility()
        updateDoneButtonEnability()
    }
}

// MARK: - UITableViewDelegate
extension FoodInputViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Utils
private extension FoodInputViewController {
    func isResultSubmittable(result: [String]) -> Bool {
        let chosenFoods = foodItems.filter { !$0.isEmpty }
        guard !chosenFoods.isEmpty else {
            return false
        }
                
        return true
    }
}

import SwiftUI
#Preview {
    FoodInputViewController.preview()
}
