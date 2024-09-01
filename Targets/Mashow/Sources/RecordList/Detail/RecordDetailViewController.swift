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
    
    private let cardView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .sojuBottle) // Replace with your asset
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let commentaryLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.text = "오늘은 알중단 사람들과 맛있는 술을 마셨당 좋사좋시~ 다음에도 같이 술 마시고 싶다!!"
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(cardView)
        view.addSubview(descriptionWrapperView)
    }
    
    private lazy var descriptionWrapperView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            commentaryLabel,
            createDetailHStack(category: "주종", detail: "소주_진로 막걸리_복순도가 하이볼_레몬 하이볼"),
            createRatingHStack(category: "평점", rating: 5),
            createDetailHStack(category: "먹은 음식", detail: "오징어 순대 해물 파전 방어회")
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(cardView.snp.width).multipliedBy(0.75)
        }
        
        descriptionWrapperView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
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
