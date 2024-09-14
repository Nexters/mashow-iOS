//
//  RecordDetailViewController.swift
//  Mashow
//
//  Created by Kai Lee on 9/1/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class RecordDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground) // Replace with your asset
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
    
    private let cardView: CardStackView = {
        let images = [UIImage(resource: .sojuCard), UIImage(resource: .beerCard), UIImage(resource: .cocktailCard)].compactMap({ $0 })
        let imageView = CardStackView(cardImages: images)
        return imageView
    }()
    
    private let commentaryLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.text = "오늘은 알중단 사람들과 맛있는 술을 마셨당. 좋사좋시~ 다음에도 같이 술 마시고 싶다!!"
        return label
    }()
    
    private let deleteRecordButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "삭제"
        button.setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.5)], for: .normal)
        button.action = #selector(didTapDeleteRecordButton)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(cardView)
        view.addSubview(descriptionWrapperContainerView)
    }
    
    private lazy var descriptionWrapperContainerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        containerView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add stack view to the container
        blurView.contentView.addSubview(descriptionWrapperView)
        descriptionWrapperView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28.5) // Content insets
            make.top.equalToSuperview().inset(40)
        }
        
        return containerView
    }()
    
    private lazy var descriptionWrapperView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            commentaryLabel,
            DividerView(color: .white.withAlphaComponent(0.1)),
            createDetailHStack(category: "주종", detail: "소주_진로 막걸리_복순도가 하이볼_레몬 하이볼"),
            createRatingHStack(category: "평점", rating: 5),
            createDetailHStack(category: "먹은 음식", detail: "오징어 순대 해물 파전 방어회")
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
        }
        
        descriptionWrapperContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cardView.snp.bottom).offset(26)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "기록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: NavigationAsset.backButtonImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))
        navigationItem.rightBarButtonItem = deleteRecordButton
    }
}


// MARK: - Actions

private extension RecordDetailViewController {
    @objc func didTapDeleteRecordButton() {
        // TODO: implement
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

private extension RecordDetailViewController {
    func createDetailHStack(category: String, detail: String) -> UIStackView {
        let categoryLabel: UILabel = {
            let label = UILabel()
            label.font = .pretendard(size: 14, weight: .medium)
            label.textColor = .white.withAlphaComponent(0.4)
            label.text = category
            label.textAlignment = .left
            return label
        }()
        
        let detailLabel: UILabel = {
            let label = UILabel()
            label.font = .pretendard(size: 18, weight: .bold)
            label.textColor = .white
            label.numberOfLines = 0
            label.text = detail
            label.textAlignment = .right
            return label
        }()
        
        let spacer = UIView()
        let hStack = UIStackView(arrangedSubviews: [categoryLabel, spacer, detailLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        hStack.spacing = 8
        
        categoryLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        spacer.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(0) // Spacer view can grow as needed
        }
        detailLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(300)
        }

        return hStack
    }
    
    func createRatingHStack(category: String, rating: Int) -> UIStackView {
        let categoryLabel: UILabel = {
            let label = UILabel()
            label.font = .pretendard(size: 14, weight: .medium)
            label.textColor = .white.withAlphaComponent(0.4)
            label.text = category
            label.textAlignment = .left
            return label
        }()
        
        let ratingView: UIStackView = {
            let stackView = UIStackView()
            let spacer = UIView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.alignment = .trailing
            stackView.distribution = .fill
            stackView.addArrangedSubview(spacer)
            
            for _ in 0..<rating {
                let star = UIImageView()
                star.contentMode = .scaleAspectFill
                star.image = UIImage(resource: .waterDrop)
                star.snp.makeConstraints { make in
                    make.width.height.equalTo(13)
                }
                stackView.addArrangedSubview(star)
            }
            
            spacer.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(0) // Spacer view can grow as needed
            }
            
            return stackView
        }()
        
        
        let spacer = UIView()
        let hStack = UIStackView(arrangedSubviews: [categoryLabel, spacer, ratingView])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
        hStack.spacing = 8
        
        categoryLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        spacer.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(0) // Spacer view can grow as needed
        }
        ratingView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(300)
        }

        return hStack
    }
}

import SwiftUI
#Preview {
    RecordDetailViewController.preview()
}
