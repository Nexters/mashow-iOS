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

class RecordDetailViewController: UIViewController {
    private let viewModel: RecordDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: RecordDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var deleteRecordButton: UIBarButtonItem = {
        UIBarButtonItem(title: "삭제",
                        style: .plain,
                        target: self,
                        action: #selector(didTapDeleteRecordButton))
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
                guard let self = self, let drinkInfo else {
                    return
                }
                
                // Update the UI with the fetched data
                if let memo = drinkInfo.memo {
                    self.commentaryLabel.text = memo
                }
                
                self.updateDetailHStacks(with: drinkInfo)
            }
            .store(in: &cancellables)
    }
    
    // Update detail HStacks with fetched data
    private func updateDetailHStacks(with drinkInfo: RecordDetailViewModel.DrinkRecordInfo) {
        cardView.setupCards(with: getCardImagesWithRandomStack(drinkType: drinkInfo.drinkType))
        
        // Remove and recreate the stack view based on the new drinkInfo
        descriptionWrapperView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        descriptionWrapperView.addArrangedSubview(commentaryLabel)
        descriptionWrapperView.addArrangedSubview(DividerView(color: .white.withAlphaComponent(0.1)))
        descriptionWrapperView.addArrangedSubview(createDetailHStack(category: "이름", detail: drinkInfo.drinkName))
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
        
        navigationItem.title = viewModel.state.dateString
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = deleteRecordButton
    }
}


// MARK: - Actions

private extension RecordDetailViewController {
    @objc func didTapDeleteRecordButton() {
        showConfirmCancelAlert(
            title: "정말로 삭제하시겠습니까?",
            message: nil,
            onConfirm: { [weak self] in
                guard let self else { return }
                
                Task {
                    do {
                        try await self.viewModel.deleteDrinkInfo()
                        self.navigationController?.popToRootViewController(animated: true)
                    } catch {
                        self.showErrorAlert()
                    }
                }
            })
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
        //        return [topmostCard] + randomCards

        // 다중선택 해제로 일단 하나만
        return [topmostCard]
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
