//
//  RecordDetailViewController.swift
//  Mashow
//
//  Created by Kai Lee on 9/1/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

import Combine
class RecordDetailViewModel {
    let state: State
    
    struct State {
        let drinkInfo = CurrentValueSubject<DrinkInfo?, Never>(nil)
    }
    
    init() {
        state = State()
    }
    
    func fetchDrinkInfo() async throws {
        state.drinkInfo.send(
            DrinkInfo(
                drinkType: .highball,
                memo: "Seed \(Int.random(in: 0...10)): 오늘은 알중단 사람들과 맛있는 술을 마셨당. 좋사좋시~ 다음에도 같이 술 마시고 싶다!!",
                rating: Int.random(in: 1...5),
                sideDishes: ["Seed \(Int.random(in: 0...10)): 소주_진로 막걸리_복순도가 하이볼_레몬 하이볼"])
        )
    }
}

extension RecordDetailViewModel {
    struct DrinkInfo {
        let drinkType: DrinkType
        let memo: String?
        let rating: Int?
        let sideDishes: [String]
    }
}

class RecordDetailViewController: UIViewController {
    private let viewModel = RecordDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .backgroundDefault)
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
        CardStackView(cardImages: [])
    }()
    
    private let commentaryLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        label.text = "" // Set dynamically based on view model data
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
        
        // Bind the view model to the UI
        bind()
        
        // Fetch the drink info from the view model
        Task { try await viewModel.fetchDrinkInfo() }
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(cardView)
        view.addSubview(descriptionWrapperContainerView)
    }
    
    private func bind() {
        viewModel.state.drinkInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] drinkInfo in
                guard let self = self, let drinkInfo = drinkInfo else {
                    return
                }
                
                // Update the UI with the fetched data
                self.commentaryLabel.text = drinkInfo.memo
                self.updateDetailHStacks(with: drinkInfo)
            }
            .store(in: &cancellables)
    }
    
    // Update detail HStacks with fetched data
    private func updateDetailHStacks(with drinkInfo: RecordDetailViewModel.DrinkInfo) {
        cardView.setupCards(with: getCardImagesWithRandomStack(drinkType: drinkInfo.drinkType))
        
        // Remove and recreate the stack view based on the new drinkInfo
        descriptionWrapperView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        descriptionWrapperView.addArrangedSubview(commentaryLabel)
        descriptionWrapperView.addArrangedSubview(DividerView(color: .white.withAlphaComponent(0.1)))
        descriptionWrapperView.addArrangedSubview(createDetailHStack(category: "주종", detail: drinkInfo.drinkType.rawValue))
        descriptionWrapperView.addArrangedSubview(createRatingHStack(category: "평점", rating: drinkInfo.rating ?? 0))
        descriptionWrapperView.addArrangedSubview(createDetailHStack(category: "먹은 음식", detail: drinkInfo.sideDishes.joined(separator: ", ")))
    }
    
    // MARK: - Properties
    
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
            createDetailHStack(category: "주종", detail: ""),
            createRatingHStack(category: "평점", rating: 0),
            createDetailHStack(category: "먹은 음식", detail: "")
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
    func getCardImagesWithRandomStack(drinkType: DrinkType) -> [UIImage] {
        let allCards: [UIImage] = [
            UIImage(resource: .sojuCard),
            UIImage(resource: .liquorCard),
            UIImage(resource: .makgeolliCard),
            UIImage(resource: .sakeCard),
            UIImage(resource: .beerCard),
            UIImage(resource: .wineCard),
            UIImage(resource: .cocktailCard),
            UIImage(resource: .highballCard)
        ]
        
        let topmostCard = switch drinkType {
        case .soju:
            UIImage(resource: .sojuCard)
        case .liquor:
            UIImage(resource: .liquorCard)
        case .makgeolli:
            UIImage(resource: .makgeolliCard)
        case .sake:
            UIImage(resource: .sakeCard)
        case .beer:
            UIImage(resource: .beerCard)
        case .wine:
            UIImage(resource: .wineCard)
        case .cocktail:
            UIImage(resource: .cocktailCard)
        case .highball:
            UIImage(resource: .highballCard)
        }
        
        
        // Remove the topmost card from the list of all cards to prevent duplication
        let remainingCards = allCards.filter { $0 != topmostCard }
        
        // Randomly select two background cards from the remaining cards
        let randomCards = remainingCards.shuffled().prefix(2)
        
        // Return the topmost card with the two randomly selected background cards
        return [topmostCard] + randomCards
    }
    
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
