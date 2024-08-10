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
    
    private var foodItems: [String] = [""]
    
    // MARK: - UI Elements
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "먹은 음식 이름 또는 종류를 적어주세요!"
        label.font = .pretendard(size: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
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
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
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
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(doneButton.snp.top).offset(-16)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
    }
    
    func setupTableFooter() {
        addFooterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableFooterView = addFooterView
        updateFooterVisibility() // Initial check
        updateDoneButtonEnability() // Initial check
    }
    
    func updateFooterVisibility() {
        if let lastItem = foodItems.last, lastItem.isEmpty {
            tableView.tableFooterView?.isHidden = true // Hide footer
        } else {
            tableView.tableFooterView?.isHidden = false // Show footer
        }
    }
    
    func updateDoneButtonEnability() {
        doneButton.isEnabled = isResultSubmittable(result: foodItems)
        doneButton.alpha = doneButton.isEnabled ? 1.0 : 0.5
    }
}

// MARK: - Actions
private extension FoodInputViewController {
    @objc func didTapAddButton() {
        foodItems.append("")
        tableView.reloadData()
        updateFooterVisibility()
    }
    
    @objc func didTapDoneButton() {
        let chosenFoods = foodItems.filter { !$0.isEmpty }
        // FIXME: fixme
        print(chosenFoods)
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
