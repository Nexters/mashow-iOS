//
//  HomeViewController.swift
//  Mashow
//
//  Created by Kai Lee on 8/12/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//
import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Elements

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .homeBackgroundDefault)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.state.nickname
        label.font = .blankSans(size: 44, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()

    lazy var showLabel: GradientLabel = {
        let view = GradientLabel()
        view.label.text = "SHOW"
        view.label.font = .blankSans(size: 44, weight: .bold)
        view.label.textColor = .white
        return view
    }()

    lazy var viewToggleStackView: ViewToggleStackView = {
        let view = ViewToggleStackView()
        return view
    }()

    lazy var drinkCardView: CardView = {
        let view = CardView()
        return view
    }()
    
    lazy var listTypeRecordViewController: ListTypeRecordViewController = {
        let view = ListTypeRecordViewController()
        return view
    }()
    
    lazy var recordButton: AddButton = {
        let button = AddButton()
        button.onTap = { [weak self] in
            guard let self else { return }
            self.didTapRecordButton()
        }
        return button
    }()

    lazy var myPageButton: CircularButton = {
        let button = CircularButton()
        button.setImage(
            UIImage(
                systemName: "person.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)),
            for: .normal)
        button.tintColor = .white
        button.backgroundColor = .hex("F2F2F2").withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(didTapMyPageButton), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSubViewController()
        setupConstraints()
        setupSubViewAction()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - View setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(showLabel)
//        view.addSubview(viewToggleStackView)
        view.addSubview(drinkCardView)
        view.addSubview(recordButton)
        view.addSubview(myPageButton)
    }
    
    private func setupSubViewController() {
        addChild(listTypeRecordViewController)
        view.addSubview(listTypeRecordViewController.view)
    }

    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view).offset(20)
        }
        nicknameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        showLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(view).offset(20)
        }
        showLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        showLabel.setColors([
            .hex("C6CEA5").withAlphaComponent(0.7),
            .hex("C5A7A7").withAlphaComponent(0.7),
            .hex("47525A")
        ])

//        viewToggleStackView.snp.makeConstraints { make in
//            make.top.equalTo(showLabel.snp.bottom).offset(16)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(194)
//            make.height.equalTo(34)
//        }
        
        drinkCardView.snp.makeConstraints { make in
//            make.top.equalTo(viewToggleStackView.snp.bottom).offset(26)
            make.top.equalTo(showLabel.snp.bottom).offset(26)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).inset(30)
            make.bottom.equalTo(recordButton.snp.top).offset(-20)
        }
        
        listTypeRecordViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(viewToggleStackView.snp.bottom).offset(26)
            make.top.equalTo(showLabel .snp.bottom).offset(26)
            make.leading.equalTo(view).offset(24)
            make.trailing.equalTo(view).inset(24)
            make.bottom.equalTo(recordButton.snp.top).offset(-25)
        }
        
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        
        myPageButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.height.width.equalTo(32)
            make.trailing.equalTo(view).inset(20)
        }
    }
    
    func setupSubViewAction() {
        viewToggleStackView.onTapCardView = { [weak self] in
            self?.showAlert(title: "Coming Soon!", message: "곧 추가됩니다")
        }
    }
    
    private func showNotDeterminedView() {
        drinkCardView.isHidden = true
        listTypeRecordViewController.view.isHidden = true
    }
    
    private func showEmptyStateView() {
        drinkCardView.isHidden = false
        listTypeRecordViewController.view.isHidden = true
    }
    
    private func showMiniCardListView(with drinkTypeList: [DrinkType]) {
        drinkCardView.isHidden = true
        listTypeRecordViewController.configure(
            nickname: viewModel.state.nickname,
            userId: viewModel.state.userId,
            availableDrinkTypes: drinkTypeList,
            refreshHomeWhenSubmitted: { [weak self] in
                guard let self else { return }
                try await self.viewModel.refresh()
            }
        )
        listTypeRecordViewController.view.isHidden = false
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.state.records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self else { return }
                
                guard let records else {
                    showNotDeterminedView()
                    return
                }
                
                if records.isEmpty {
                    showEmptyStateView()
                } else {
                    showMiniCardListView(with: Array(records))
                }
            }
            .store(in: &cancellables)
        
        viewModel.state.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                
                self.showErrorAlert()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Action

extension HomeViewController {
    @objc private func didTapRecordButton() {
        let vc = DrinkSelectionViewController(
            viewModel: .init(
                state: .init(
                    initialDrinkType: .soju),
                action: .init(
                    onSubmitted: { [weak self] in
                        guard let self else { return }
                        try await self.viewModel.refresh()
                    }))
        )
        
        show(vc, sender: nil)
    }
    
    @objc private func didTapMyPageButton() {
        let vc = MyPageViewController(
            viewModel: MyPageViewModel(
                state: .init(accessTokenSubject: viewModel.state.accessToken)))
        
        show(vc, sender: nil)
    }
}

import SwiftUI
#Preview {
    HomeViewController.preview {
        let vc = HomeViewController()
        vc.viewModel = .init(state: .init(nickname: "Temp한글", 
                                          userId: 1,
                                          accessToken: .init(nil)))
        vc.viewModel.state.records.send([.soju, .beer, .wine])
        return vc
    }
}
