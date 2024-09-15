//
//  DrinkDetailViewController.swift
//  MashowTests
//
//  Created by ZENA on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import Combine

class DrinkDetailViewController: DrinkSelectionSubViewController {
    private let viewModel = DrinkDetailViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .backgroundDefault)
        imageView.contentMode = .scaleAspectFill

        let dimmingView = UIView()
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.5

        imageView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "기억하고 싶은\n술의 이름 또는 종류를 적어주세요!"
        label.textAlignment = .left
        label.textColor = UIColor.hex("F3F3F3")
        label.font = .pretendard(size: 20, weight: .semibold)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DrinkCell.self, forCellReuseIdentifier: DrinkCell.identifier)
        tableView.separatorStyle = .none
        
        // Enable automatic dimension for cell height
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    func makeFooterView() -> UIView {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
        
        // 기본 셀 잡아줌
        environmentViewModel.state.addedTypes.value.forEach { type in
            viewModel.drinkDetails[type] = [""]
        }
    }
    
    @objc override func didTapBackButton() {
        environmentViewModel.flush()
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func didTapNextButton() {
        let vc = RatingViewController()
        vc.environmentViewModel = environmentViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension DrinkDetailViewController {
    private func setupLayouts() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(buttonStackView.snp.top)
        }
    }
}

extension DrinkDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return environmentViewModel.state.addedTypes.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let drinkType = environmentViewModel.state.addedTypes.value[section]
        return viewModel.drinkDetails[drinkType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DrinkCell.identifier, for: indexPath) as? DrinkCell else {
            return UITableViewCell()
        }
        
        let drinkType = environmentViewModel.state.addedTypes.value[indexPath.section]
        if let detail = viewModel.drinkDetails[drinkType]?[indexPath.row] {
            cell.configure(with: detail, section: indexPath.section, row: indexPath.row)
        }

        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.onTapDelete { [weak self] in
            // Delete specific row
            self?.viewModel.drinkDetails[drinkType]?.remove(at: indexPath.row)
            self?.tableView.reloadData()
        }
        // To fix buggy reused cells
        cell.textField.showDeleteButtonIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let drinkTypeLabel = UILabel()
        drinkTypeLabel.text = environmentViewModel.state.addedTypes.value[section].korean
        drinkTypeLabel.textColor = .white
        drinkTypeLabel.font = .pretendard(size: 16, weight: .semibold)
        
        headerView.addSubview(drinkTypeLabel)
        drinkTypeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        return headerView
    }
    
    // 섹션 푸터 ("추가하기" 버튼)
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("+ 추가하기", for: .normal)
        addButton.titleLabel?.font = .pretendard(size: 14, weight: .regular)
        addButton.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        addButton.tag = section
        addButton.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
        
        footerView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - Actions

extension DrinkDetailViewController {
    @objc private func didTapAddButton(_ sender: UIButton) {
        let section = sender.tag
        let drinkType = environmentViewModel.state.addedTypes.value[section]
        viewModel.drinkDetails[drinkType, default: []].append("")
        
        print(viewModel.drinkDetails)
        
        UIView.performWithoutAnimation {
            tableView.reloadSections([section], with: .none)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Find the cell that contains this text field
        if let cell = textField.superview(of: DrinkCell.self),
           let section = cell.section,
           let row = cell.row {
            let drinkType = environmentViewModel.state.addedTypes.value[section]
            viewModel.drinkDetails[drinkType]?[row] = textField.text ?? ""
        }
    }
}

private extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        var currentSuperview = self.superview
        while let superview = currentSuperview {
            if let typedSuperview = superview as? T {
                return typedSuperview
            }
            currentSuperview = superview.superview
        }
        return nil
    }
}
