//
//  DrinkDetailViewController.swift
//  MashowTests
//
//  Created by ZENA on 8/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import Combine

final class DrinkDetailViewController: UIViewController {
    
    let viewModel = DrinkDetailViewModel()
    
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
    
    private lazy var drinkTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "소주"
        label.textColor = .white
        label.font = .pretendard(size: 16, weight: .semibold)
        return label
    }()
    
    private lazy var prevButton: UIButton = {
        let button = BlurredButton()
        button.updateBlurEffectStyle(.light)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.setTitle("이전", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .semibold)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = BlurredButton()
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.hex("FCFCFC"), for: .normal)
        button.titleLabel?.font = .pretendard(size: 20, weight: .semibold)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(prevButton)
        stackView.addArrangedSubview(nextButton)
        return stackView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableFooter()
        setupLayouts()
    }
}

private extension DrinkDetailViewController {
    
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
    
    private func setupTableFooter() {
        addFooterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableFooterView = addFooterView
    }
    
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
        
        view.addSubview(drinkTypeLabel)
        drinkTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
        }
        
        view.addSubview(tableView)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(drinkTypeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView)
        }
    }
    
    @objc private func didTapAddButton() {
        viewModel.drinkDetails.append("")
        tableView.reloadData()
    }
}

private extension DrinkDetailViewController {
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension DrinkDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension DrinkDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinkDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.identifier, for: indexPath) as? FoodCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.drinkDetails[indexPath.row], tag: indexPath.row)
        cell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.onTapDelete { [weak self] in
            self?.viewModel.drinkDetails.remove(at: indexPath.row)
            self?.tableView.reloadData()
        }
        cell.textField.showDeleteButtonIfNeeded()
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.drinkDetails[textField.tag] = textField.text ?? ""
    }
}
