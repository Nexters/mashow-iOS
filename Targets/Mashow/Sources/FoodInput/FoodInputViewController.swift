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
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        addButton.setTitleColor(.white, for: .normal)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
    }
}

// MARK: - Actions
private extension FoodInputViewController {
    @objc func didTapAddButton() {
        foodItems.append("")
        tableView.reloadData()
    }
    
    @objc func didTapDoneButton() {
        // Handle completion logic, such as saving the entered food items.
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
    }
}

// MARK: - UITableViewDelegate
extension FoodInputViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

import SwiftUI
#Preview {
    FoodInputViewController.preview()
}
