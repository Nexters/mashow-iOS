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
    
    private let tableScrollView = UIScrollView()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
        setupTableViews()
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
    
    private func setupTableViews() {
        for (drinkType, _) in viewModel.drinkDetails {
            let singleView = SingleDrinkDetailView(
                drinkType: drinkType,
                viewModel: viewModel
            )
            let prevView = tableScrollView.subviews.last
            tableScrollView.addSubview(singleView)
            singleView.setupSelf()
            if let prevView {
                singleView.snp.makeConstraints { make in
                    make.top.equalTo(prevView.snp.bottom)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(singleView.tableView.contentSize.height + 100)
                }
            } else {
                singleView.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(singleView.tableView.contentSize.height + 100)
                }
            }
        }
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
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(60)
        }
        
        view.addSubview(tableScrollView)
        tableScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(buttonStackView.snp.top)
        }
    }
}

private extension DrinkDetailViewController {
    private func bind() {
        // TODO: - layoutIfNeeded()
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
