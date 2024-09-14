//
//  SingleDrinkDetailViewController.swift
//  Mashow
//
//  Created by ZENA on 9/14/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit

// MARK: - Details of single type
class SingleDrinkDetailView: UIStackView {
    
    var drinkType: DrinkType
    var viewModel: DrinkDetailViewModel
    
    override init(frame: CGRect) {
        // FIXME: - 더미값인데 여기서 꼭 초기화해주어야 하는것인가 ...
        self.drinkType = .beer
        self.viewModel = DrinkDetailViewModel()
        super.init(frame: frame)
    }
    
    convenience init(drinkType: DrinkType, viewModel: DrinkDetailViewModel) {
        self.init(frame: .zero)
        self.drinkType = drinkType
        self.viewModel = viewModel
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var drinkTypeLabel: UILabel = {
        let label = UILabel()
        label.text = drinkType.korean
        label.textColor = .white
        label.font = .pretendard(size: 16, weight: .semibold)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FoodCell.self, forCellReuseIdentifier: FoodCell.identifier)
        tableView.separatorStyle = .none
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
    
    // MARK: - Functions
    func setupSelf() {
        self.axis = .vertical
        self.spacing = 24
        tableView.isScrollEnabled = false
        self.addArrangedSubview(drinkTypeLabel)
        self.addArrangedSubview(tableView)
        addFooterView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        tableView.tableFooterView = addFooterView
    }
    
    @objc private func didTapAddButton() {
        viewModel.drinkDetails[drinkType]?.append("")
        tableView.reloadData()
    }
}

extension SingleDrinkDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension SingleDrinkDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let details = viewModel.drinkDetails[drinkType] else { return 0 }
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.identifier, for: indexPath) as? FoodCell,
            let details = viewModel.drinkDetails[drinkType] else {
            return UITableViewCell()
        }
        
        cell.configure(with: details[indexPath.row], tag: indexPath.row)
        cell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.onTapDelete { [weak self] in
            guard let self else { return }
            self.viewModel.drinkDetails[self.drinkType]!.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        cell.textField.showDeleteButtonIfNeeded()
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.drinkDetails[drinkType]![textField.tag] = textField.text ?? ""
    }
}
